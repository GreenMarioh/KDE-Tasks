import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.greenmarioh.kdetasks // Matches the URI defined in CMake
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    // Instantiate the C++ Controller
    TasksController {
        id: tasksController
    }

    // Set the preferred representation (the list of tasks)
    fullRepresentation: Item {
        // Plasma 6 uses Kirigami.Units for consistent sizing
        Layout.preferredWidth: Kirigami.Units.gridUnit * 20
        Layout.preferredHeight: Kirigami.Units.gridUnit * 25

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.smallSpacing
            spacing: Kirigami.Units.smallSpacing

            // Show a login button if the model is empty (needs authentication)
            PlasmaComponents.Button {
                text: i18n("Login to Google Tasks")
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
                    model: tasksController.tasksModel // Bind to C++ Model
                    clip: true
                    
                    delegate: PlasmaComponents.ItemDelegate {
                        width: listView.width
                        
                        contentItem: RowLayout {
                            spacing: Kirigami.Units.smallSpacing

                            PlasmaComponents.CheckBox {
                                checked: model.completed
                                onToggled: model.completed = checked
                            }
                            
                            PlasmaComponents.Label {
                                text: model.title
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                font.strikeout: model.completed
                                opacity: model.completed ? 0.6 : 1.0
                            }
                        }
                    }
                }
            }
        }
    }

    // Compact representation (icon on the panel)
    // FIX: Replaced PlasmaCore.IconItem with Kirigami.Icon for Plasma 6
    compactRepresentation: Kirigami.Icon {
        source: "task-accepted"
        activeFocusOnTab: true
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (root.expanded) {
                    root.expanded = false;
                } else {
                    tasksController.refreshTasks();
                    root.expanded = true;
                }
            }
        }
    }
    
    // Initial fetch when the widget loads
    Component.onCompleted: {
        tasksController.refreshTasks();
    }
}