#include "networkmanager.h"
#include <QNetworkRequest>
#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

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
    QNetworkRequest request(url);
    request.setRawHeader("Authorization", "Bearer " + m_accessToken.toUtf8());

    QNetworkReply *reply = m_manager->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onTasksReceived(reply);
    });
}

void NetworkManager::onTasksReceived(QNetworkReply *reply) {
    reply->deleteLater();

    if (reply->error() != QNetworkReply::NoError) {
        Q_EMIT errorOccurred(reply->errorString());
        return;
    }

    QByteArray data = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonObject obj = doc.object();
    QJsonArray items = obj[QStringLiteral("items")].toArray();

    std::vector<TaskItem> tasks;
    for (const QJsonValue &value : items) {
        QJsonObject taskObj = value.toObject();
        tasks.push_back({
            taskObj[QStringLiteral("id")].toString(),
            taskObj[QStringLiteral("title")].toString(),
            taskObj[QStringLiteral("status")].toString() == QStringLiteral("completed")
        });
    }

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