#ifndef TASKSCONTROLLER_H
#define TASKSCONTROLLER_H

#include <QObject>
#include <QOAuth2AuthorizationCodeFlow> // FIX: Provides the definition for the OAuth pointer
#include <KWallet>                      // FIX: Updated for KF6 standard
#include "taskmodel.h"
#include "networkmanager.h"

class TasksController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(TasksModel* tasksModel READ tasksModel CONSTANT)

public:
    explicit TasksController(QObject *parent = nullptr);
    TasksModel* tasksModel() const { return m_tasksModel; }

    Q_INVOKABLE void refreshTasks();
    Q_INVOKABLE void authenticate();
    Q_INVOKABLE void addTask(const QString &title);
    Q_INVOKABLE void setTaskCompleted(const QString &taskId, bool completed);

private:
    void loadCredentialsFromWallet();

    TasksModel *m_tasksModel;
    NetworkManager *m_networkManager;
    QOAuth2AuthorizationCodeFlow *m_googleAuth;
    KWallet::Wallet *m_wallet = nullptr;
};

#endif
