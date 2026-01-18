#ifndef TASKSCONTROLLER_H
#define TASKSCONTROLLER_H

#include <QObject>
#include "taskmodel.h"
#include "networkmanager.h"
#include <KWallet>

class TasksController : public QObject
{
    Q_OBJECT
    // Expose the model so QML can bind to it
    Q_PROPERTY(TasksModel* tasksModel READ tasksModel CONSTANT)

public:
    explicit TasksController(QObject *parent = nullptr);

    TasksModel* tasksModel() const { return m_tasksModel; }

    // QML-accessible method to trigger a refresh
    Q_INVOKABLE void refreshTasks();
    void authenticate();

private:
    void loadCredentialsFromWallet();

    TasksModel *m_tasksModel;
    NetworkManager *m_networkManager;
    QOAuth2AuthorizationCodeFlow *m_googleAuth;
    KWallet::Wallet *m_wallet = nullptr;
};

#endif 