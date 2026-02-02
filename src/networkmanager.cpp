#include "networkmanager.h"
#include <QNetworkRequest>
#include <QUrl>
#include <QUrlQuery>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

NetworkManager::NetworkManager(QObject *parent) 
    : QObject(parent)
    , m_manager(new QNetworkAccessManager(this))
{
}

void NetworkManager::setAccessToken(const QString &token) {
    m_accessToken = token;
}

void NetworkManager::fetchTasks(const QString &listId) {
    if (m_accessToken.isEmpty()) {
        Q_EMIT errorOccurred(QStringLiteral("No access token set"));
        return;
    }

    QUrl url(QStringLiteral("https://www.googleapis.com/tasks/v1/lists/%1/tasks").arg(listId));
    QUrlQuery query;
    query.addQueryItem(QStringLiteral("showCompleted"), QStringLiteral("true"));
    query.addQueryItem(QStringLiteral("showHidden"), QStringLiteral("true"));
    query.addQueryItem(QStringLiteral("maxResults"), QStringLiteral("100"));
    query.addQueryItem(QStringLiteral("fields"), QStringLiteral("items(id,title,status)"));
    url.setQuery(query);
    qDebug() << "Fetching tasks from:" << url.toString();
    QNetworkRequest request(url);
    request.setRawHeader("Authorization", "Bearer " + m_accessToken.toUtf8());

    QNetworkReply *reply = m_manager->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onTasksReceived(reply);
    });
}

void NetworkManager::onTasksReceived(QNetworkReply *reply) {
    reply->deleteLater();
    const int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    qDebug() << "Tasks fetch HTTP status:" << statusCode;

    if (reply->error() != QNetworkReply::NoError) {
        const QByteArray payload = reply->readAll();
        const QString details = payload.isEmpty() ? reply->errorString()
                                                  : QString::fromUtf8(payload);
        Q_EMIT errorOccurred(details);
        return;
    }

    QByteArray data = reply->readAll();
    qDebug() << "Tasks fetch response bytes:" << data.size();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (!doc.isObject()) {
        qDebug() << "Tasks fetch: response is not a JSON object";
        Q_EMIT errorOccurred(QStringLiteral("Tasks fetch returned non-object JSON."));
        return;
    }
    QJsonObject obj = doc.object();
    const QJsonValue itemsValue = obj.value(QStringLiteral("items"));
    QJsonArray items = itemsValue.toArray();
    qDebug() << "Tasks fetch items count:" << items.size();
    if (items.isEmpty()) {
        qDebug() << "Tasks fetch object keys:" << obj.keys();
    }

    std::vector<TaskItem> tasks;
    for (const QJsonValue &value : items) {
        QJsonObject taskObj = value.toObject();
        if (tasks.size() < 3) {
            qDebug() << "Task sample:" << taskObj.keys();
        }
        tasks.push_back({
            taskObj[QStringLiteral("id")].toString(),
            taskObj[QStringLiteral("title")].toString(),
            taskObj[QStringLiteral("status")].toString() == QStringLiteral("completed")
        });
    }

    qDebug() << "Tasks parsed:" << static_cast<int>(tasks.size());
    Q_EMIT tasksFetched(tasks);
}

void NetworkManager::updateTaskStatus(const QString &listId, const QString &taskId, bool completed) {
    if (m_accessToken.isEmpty()) return;

    QUrl url(QStringLiteral("https://www.googleapis.com/tasks/v1/lists/%1/tasks/%2").arg(listId, taskId));
    QNetworkRequest request(url);
    request.setRawHeader("Authorization", "Bearer " + m_accessToken.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, QStringLiteral("application/json"));

    QJsonObject body;
    body[QStringLiteral("status")] = completed ? QStringLiteral("completed") : QStringLiteral("needsAction");
    
    m_manager->sendCustomRequest(request, "PATCH", QJsonDocument(body).toJson());
}

void NetworkManager::addTask(const QString &listId, const QString &title) {
    if (m_accessToken.isEmpty()) {
        Q_EMIT errorOccurred(QStringLiteral("No access token set"));
        return;
    }

    QUrl url(QStringLiteral("https://www.googleapis.com/tasks/v1/lists/%1/tasks").arg(listId));
    QNetworkRequest request(url);
    request.setRawHeader("Authorization", "Bearer " + m_accessToken.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, QStringLiteral("application/json"));

    QJsonObject body;
    body[QStringLiteral("title")] = title;

    QNetworkReply *reply = m_manager->post(request, QJsonDocument(body).toJson());
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();

        if (reply->error() != QNetworkReply::NoError) {
            const QByteArray payload = reply->readAll();
            const QString details = payload.isEmpty() ? reply->errorString()
                                                      : QString::fromUtf8(payload);
            Q_EMIT errorOccurred(details);
            return;
        }

        Q_EMIT taskAdded();
    });
}
