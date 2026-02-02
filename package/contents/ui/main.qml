import QtQuick
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root
    
    // CRITICAL: Tell the viewer to show the full list immediately
    preferredRepresentation: fullRepresentation

    fullRepresentation: Item {
        implicitWidth: Kirigami.Units.gridUnit * 25
        implicitHeight: Kirigami.Units.gridUnit * 30

        TasksPage {
            anchors.fill: parent
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
