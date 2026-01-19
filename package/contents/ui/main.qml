import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.greenmarioh.kdetasks 

PlasmoidItem {
    id: root
    
    // CRITICAL: Tell the viewer to show the full list immediately
    preferredRepresentation: fullRepresentation

    TasksController {
        id: tasksController
    }

    fullRepresentation: Item {
        // Explicit sizes are required for the standalone viewer
        implicitWidth: Kirigami.Units.gridUnit * 25
        implicitHeight: Kirigami.Units.gridUnit * 30

        Rectangle {
            anchors.fill: parent
            color: Kirigami.Theme.backgroundColor
            
            // Temporary border to verify rendering boundaries
            border.color: "red"
            border.width: 1
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Kirigami.Units.gridUnit
                spacing: Kirigami.Units.smallSpacing

                // Debug Header
                PlasmaComponents.Label {
                    text: "Backend: " + (tasksController !== null ? "✅ Active" : "❌ Error")
                    Layout.alignment: Qt.AlignHCenter
                    color: Kirigami.Theme.highlightColor
                }

                // Login Button
                // FIX: Added () to rowCount
                PlasmaComponents.Button {
                    text: i18n("Login to Google Tasks")
                    Layout.fillWidth: true
                    visible: tasksController.tasksModel.rowCount() === 0
                    onClicked: tasksController.authenticate()
                }

                // Task List
                // FIX: Added () to rowCount
                PlasmaComponents.ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: tasksController.tasksModel.rowCount() > 0

                    ListView {
                        id: listView
                        model: tasksController.tasksModel
                        clip: true
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
    }

    compactRepresentation: Kirigami.Icon {
        source: "task-accepted"
        MouseArea {
            anchors.fill: parent
            onClicked: root.expanded = !root.expanded
        }
    }
}