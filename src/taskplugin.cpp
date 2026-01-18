#include <QQmlEngine>
#include "taskscontroller.h"
#include "tasksplugin.h"

void TasksPlugin::registerTypes(const char *uri) {
    // Register the controller so it can be used in QML
    qmlRegisterType<TasksController>(uri, 1, 0, "TasksController");
    
    // We still register the model type so QML understands the property type
    qmlRegisterType<TasksModel>(uri, 1, 0, "TasksModel");
}