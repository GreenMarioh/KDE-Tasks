import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.greenmarioh.kdetasks // This matches the URI in CMake

PlasmoidItem {
    id: root

    // Instantiate our C++ Controller
    TasksController {
        id: tasksController
    }

    // Set the preferred representation (the list of tasks)
    fullRepresentation: Item {
        Layout.preferredWidth: PlasmaCore.Units.gridUnit * 20
        Layout.preferredHeight: PlasmaCore.Units.gridUnit * 25

        ColumnLayout {
            anchors.fill: parent
            spacing: PlasmaCore.Units.smallSpacing

            // Show a login button if the model is empty (needs authentication)
            PlasmaComponents.Button {
                text: "Login to Google Tasks"
                Layout.alignment: Qt.AlignCenter
                visible: tasksController.tasksModel.rowCount === 0
                onClicked: tasksController.authenticate()
            }

            // The scrollable list of tasks
            PlasmaComponents.ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: tasksController.tasksModel.rowCount > 0

                ListView {
                    id: listView
                    model: tasksController.tasksModel // Bind to our C++ Model
                    
                    delegate: PlasmaComponents.ItemDelegate {
                        width: listView.width
                        
                        contentItem: RowLayout {
                            PlasmaComponents.CheckBox {
                                checked: model.completed
                                onToggled: model.completed = checked
                            }
                            
                            PlasmaComponents.Label {
                                text: model.title
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                font.strikeout: model.completed
                            }
                        }
                    }
                }
            }
        }
    }

    // Compact representation (icon on the panel)
    compactRepresentation: PlasmaCore.IconItem {
        source: "task-accepted"
        MouseArea {
            anchors.fill: parent
            onClicked: tasksController.refreshTasks()
        }
    }
    
    // Initial fetch when the widget loads
    Component.onCompleted: {
        tasksController.refreshTasks()
    }
}