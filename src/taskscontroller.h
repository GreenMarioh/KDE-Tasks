#ifndef TASKSCONTROLLER_H
#define TASKSCONTROLLER_H

#include <QObject>
#include "taskmodel.h"
#include "networkmanager.h"

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

private:
    TasksModel *m_tasksModel;
    NetworkManager *m_networkManager;
};

#endif 