import QtQuick 2.15
import QtQuick.Window 2.15
import "package/contents/ui" as TasksUi

Window {
    id: window
    width: 560
    height: 720
    visible: true
    title: "KDE Tasks"

    TasksPageStandalone {
        anchors.fill: parent
    }
}
