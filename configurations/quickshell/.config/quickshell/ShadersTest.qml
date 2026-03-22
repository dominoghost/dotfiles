import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland

PanelWindow {
    // Since the panel's screen is unset, it will be picked by the compositor
    // when the window is created. Most compositors pick the current active monitor.

    anchors.right: true
    margins.right: 100
    exclusiveZone: 0
    implicitWidth: 400
    implicitHeight: 400
    WlrLayershell.namespace: "QSShaders"
    color: "transparent"

    Rectangle {
        color: "black"
        anchors.fill: parent

        ShaderEffect {
            id: phaseShader

            property real time: 0

            anchors.fill: parent
            fragmentShader: "shader.frag.qsb"

            NumberAnimation on time {
                loops: Animation.Infinite
                from: 0
                to: 100000
                duration: 100000
                easing.type: Easing.Linear
            }

        }

    }

}
