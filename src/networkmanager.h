#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include "taskmodel.h"

class NetworkManager : public QObject
{
    Q_OBJECT

public:
    explicit NetworkManager(QObject *parent = nullptr);

    // Call this with your OAuth2 access token
    void setAccessToken(const QString &token);
    
    // API Methods
    void fetchTasks(const QString &listId = "@default");
    void updateTaskStatus(const QString &listId, const QString &taskId, bool completed);

signals:
    void tasksFetched(const std::vector<TaskItem> &tasks);
    void errorOccurred(const QString &error);

private slots:
    void onTasksReceived(QNetworkReply *reply);

private:
    QNetworkAccessManager *m_manager;
    QString m_accessToken;
};

#endif // NETWORKMANAGER_H