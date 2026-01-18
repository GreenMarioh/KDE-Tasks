#ifndef TASKSPLUGIN_H
#define TASKSPLUGIN_H

#include <QQmlExtensionPlugin>

class TasksPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri) override;
};

#endif