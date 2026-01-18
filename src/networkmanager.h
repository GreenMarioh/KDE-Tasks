#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QString>
#include "taskmodel.h"

class NetworkManager : public QObject
{
    Q_OBJECT

public:
    explicit NetworkManager(QObject *parent = nullptr);

    void setAccessToken(const QString &token);
    void fetchTasks(const QString &listId = QStringLiteral("@default"));
    void updateTaskStatus(const QString &listId, const QString &taskId, bool completed);

Q_SIGNALS:
    void tasksFetched(const std::vector<TaskItem> &tasks);
    void errorOccurred(const QString &error);

private Q_SLOTS:
    void onTasksReceived(QNetworkReply *reply);

private:
    QNetworkAccessManager *m_manager;
    QString m_accessToken;
};

#endif // NETWORKMANAGER_H