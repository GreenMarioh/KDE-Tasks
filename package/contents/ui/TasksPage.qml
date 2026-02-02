import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.greenmarioh.kdetasks

Item {
    id: root

    // Explicit sizes are required for the standalone viewer
    implicitWidth: Kirigami.Units.gridUnit * 25
    implicitHeight: Kirigami.Units.gridUnit * 30

    property bool showCompleted: true

    TasksController {
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
            id: headerBackground
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: Kirigami.Units.gridUnit * 4.5
            radius: Kirigami.Units.largeSpacing
            color: Kirigami.Theme.alternateBackgroundColor
            opacity: 0.95

            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.lighter(Kirigami.Theme.alternateBackgroundColor, 1.08) }
                GradientStop { position: 1.0; color: Kirigami.Theme.backgroundColor }
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.gridUnit
            spacing: Kirigami.Units.smallSpacing

            RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

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

                PlasmaComponents.ToolButton {
                    icon.name: "view-refresh"
                    text: i18n("Refresh")
                    onClicked: tasksController.refreshTasks()
                }

                PlasmaComponents.ToolButton {
                    icon.name: "dialog-password"
                    text: i18n("Sign In")
                    onClicked: tasksController.authenticate()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                PlasmaComponents.Label {
                    text: i18n("Total: %1", tasksController.tasksModel.rowCount())
                    opacity: 0.7
                }

                Item { Layout.fillWidth: true }

                PlasmaComponents.CheckBox {
                    text: i18n("Show completed")
                    checked: showCompleted
                    onToggled: showCompleted = checked
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                Rectangle {
                    Layout.fillWidth: true
                    radius: Kirigami.Units.smallSpacing
                    color: Kirigami.Theme.alternateBackgroundColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Kirigami.Units.smallSpacing
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
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                PlasmaComponents.ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: tasksController.tasksModel.rowCount() > 0

                    ListView {
                        id: listView
                        model: tasksController.tasksModel
                        clip: true
                        spacing: Kirigami.Units.smallSpacing

                        delegate: Item {
                            width: listView.width
                            height: card.implicitHeight
                            visible: showCompleted || !model.completed
                            opacity: visible ? 1 : 0

                            Rectangle {
                                id: card
                                width: parent.width
                                radius: Kirigami.Units.smallSpacing
                                color: Kirigami.Theme.alternateBackgroundColor

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: Kirigami.Units.smallSpacing
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
                                        spacing: 0

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
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: tasksController.tasksModel.rowCount() === 0

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
        }
    }
}
