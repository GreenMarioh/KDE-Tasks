#include "taskscontroller.h"

TasksController::TasksController(QObject *parent)
    : QObject(parent),
      m_tasksModel(new TasksModel(this)),
      m_networkManager(new NetworkManager(this))
{
    // STEP 9 CONNECTION: 
    // When the network manager gets data from Google, update the model
    connect(m_networkManager, &NetworkManager::tasksFetched, 
            m_tasksModel, &TasksModel::setTasks);

    // Optional: Connect errors to a handler
    connect(m_networkManager, &NetworkManager::errorOccurred, this, [](const QString &error){
        qWarning() << "Google Tasks Error:" << error;
    });
}

void TasksController::refreshTasks() {
    // You would pass your stored OAuth token here
    m_networkManager->fetchTasks();
}