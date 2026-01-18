#include "taskscontroller.h"
#include <QDebug>

TasksController::TasksController(QObject *parent)
    : QObject(parent),
      m_tasksModel(new TasksModel(this)),
      m_networkManager(new NetworkManager(this))
{
    connect(m_networkManager, &NetworkManager::tasksFetched, 
            m_tasksModel, &TasksModel::setTasks);

    connect(m_networkManager, &NetworkManager::errorOccurred, this, [](const QString &error){
        qWarning() << "Google Tasks Error:" << error;
    });
}

void TasksController::refreshTasks() {
    // Note: You'll need to call setAccessToken() before this in your final logic
    m_networkManager->fetchTasks();
}