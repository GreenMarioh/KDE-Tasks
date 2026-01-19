import QtQuick
import org.greenmarioh.kdetasks

Window {
    visible: true
    width: 200; height: 200
    TasksController { id: ctrl }
    Text { text: "Controller Loaded: " + (ctrl !== null) }
}