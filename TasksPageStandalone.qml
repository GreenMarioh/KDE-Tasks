import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import "build/bin/org/greenmarioh/kdetasks" as TasksBackend

Item {
    id: root

    implicitWidth: Kirigami.Units.gridUnit * 25
    implicitHeight: Kirigami.Units.gridUnit * 30

    property bool showCompleted: true

    TasksBackend.TasksController {
        id: tasksController
    }

    function submitTask() {
        var title = newTaskField.text.trim();
        if (title.length === 0) {
            return;
        }
        tasksController.addTask(title);
        newTaskField.text = "";
    }

    Rectangle {
        anchors.fill: parent
        color: Kirigami.Theme.backgroundColor

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.lighter(Kirigami.Theme.backgroundColor, 1.03) }
                GradientStop { position: 1.0; color: Kirigami.Theme.backgroundColor }
            }
            opacity: 0.9
        }

        Item {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.gridUnit * 1.5

            ColumnLayout {
                id: contentColumn
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(parent.width, Kirigami.Units.gridUnit * 30)
                spacing: Kirigami.Units.gridUnit

                Rectangle {
                    Layout.fillWidth: true
                    radius: Kirigami.Units.largeSpacing
                    color: Kirigami.Theme.alternateBackgroundColor
                    opacity: 0.95
                    border.color: Qt.lighter(Kirigami.Theme.alternateBackgroundColor, 1.12)
                    border.width: 1
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 4.5

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Kirigami.Units.gridUnit * 0.75
                        spacing: Kirigami.Units.smallSpacing

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Kirigami.Heading {
                                text: i18n("KDE Tasks")
                                level: 1
                                font.bold: true
                            }

                            PlasmaComponents.Label {
                                text: Qt.formatDate(new Date(), "dddd, MMM d")
                                opacity: 0.7
                            }
                        }

                        PlasmaComponents.Button {
                            icon.name: "view-refresh"
                            text: i18n("Refresh")
                            onClicked: tasksController.refreshTasks()
                        }

                        PlasmaComponents.Button {
                            icon.name: "dialog-password"
                            text: i18n("Sign In")
                            onClicked: tasksController.authenticate()
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    PlasmaComponents.Label {
                        text: i18n("Total: %1", listView.count)
                        opacity: 0.7
                    }

                    Item { Layout.fillWidth: true }

                    PlasmaComponents.CheckBox {
                        text: i18n("Show completed")
                        checked: showCompleted
                        onToggled: showCompleted = checked
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    radius: Kirigami.Units.largeSpacing
                    color: Kirigami.Theme.alternateBackgroundColor
                    border.color: Qt.lighter(Kirigami.Theme.alternateBackgroundColor, 1.12)
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Kirigami.Units.smallSpacing * 1.5
                        spacing: Kirigami.Units.smallSpacing

                        PlasmaComponents.TextField {
                            id: newTaskField
                            Layout.fillWidth: true
                            placeholderText: i18n("Add a task")
                            onAccepted: submitTask()
                        }

                        PlasmaComponents.Button {
                            icon.name: "list-add"
                            text: i18n("Add")
                            enabled: newTaskField.text.trim().length > 0
                            onClicked: submitTask()
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Kirigami.Units.smallSpacing

                    ListView {
                        id: listView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: listView.count > 0
                        model: tasksController.tasksModel
                        clip: true
                        spacing: Kirigami.Units.smallSpacing
                        boundsBehavior: Flickable.StopAtBounds

                        delegate: Item {
                            width: listView.width
                            height: card.implicitHeight
                            visible: showCompleted || !model.completed
                            opacity: visible ? 1 : 0

                            Rectangle {
                                id: card
                                width: parent.width
                                radius: Kirigami.Units.largeSpacing
                                color: Kirigami.Theme.alternateBackgroundColor
                                border.color: Qt.lighter(Kirigami.Theme.alternateBackgroundColor, 1.1)
                                border.width: 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: Kirigami.Units.smallSpacing * 1.5
                                    spacing: Kirigami.Units.smallSpacing

                                    PlasmaComponents.CheckBox {
                                        checked: model.completed
                                        onToggled: {
                                            model.completed = checked;
                                            tasksController.setTaskCompleted(model.taskId, checked);
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2

                                        PlasmaComponents.Label {
                                            text: model.title
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                            font.strikeout: model.completed
                                        }

                                        PlasmaComponents.Label {
                                            text: model.completed ? i18n("Completed") : i18n("Active")
                                            opacity: 0.6
                                            font.pointSize: Kirigami.Theme.smallFont.pointSize
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: listView.count === 0

                        Kirigami.PlaceholderMessage {
                            anchors.centerIn: parent
                            icon.name: "task-accepted"
                            text: i18n("No tasks yet")
                            helpfulAction: Kirigami.Action {
                                text: i18n("Add your first task")
                                icon.name: "list-add"
                                onTriggered: newTaskField.forceActiveFocus()
                            }
                            explanation: i18n("Type a task above and hit Enter.")
                        }
                    }
                }

                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    visible: tasksController.lastError.length > 0
                    text: tasksController.lastError
                    color: Kirigami.Theme.negativeTextColor
                    wrapMode: Text.WordWrap
                }

                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    text: i18n("Loaded tasks: %1", listView.count)
                    opacity: 0.6
                }
            }
        }
    }
}
