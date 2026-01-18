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
    fullRepresentation: PlasmaComponents.ScrollView {
        Layout.preferredWidth: PlasmaCore.Units.gridUnit * 20
        Layout.preferredHeight: PlasmaCore.Units.gridUnit * 25

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

    // A refresh button in the header or compact representation
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