import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    // Since the panel's screen is unset, it will be picked by the compositor
    // when the window is created. Most compositors pick the current active monitor.

    exclusiveZone: 0
    implicitWidth: 800
    implicitHeight: 800
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.namespace: "QSAppLauncher"
    color: "transparent"

    Row {
        anchors.fill: parent

        WrapperRectangle {
            id: wrapRect

            height: parent.height
            width: parent.width / 2
            border.color: "white"
            border.width: 1
            color: "#cc000000"

            child: AnimatedImage {
                id: bgStuff

                source: "LainLaugh.gif"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
                visible: true
                layer.enabled: true

                layer.effect: ShaderEffect {
                    // Uniforms
                    // Point to the SOURCE, not the Box
                    property real fizzleAmount: 0.02
                    property real time: 0

                    fragmentShader: "fizzle.frag.qsb"

                    // --- Animations ---
                    NumberAnimation on time {
                        from: 0 // Set running for testing
                        to: 100
                        duration: 100000
                        loops: Animation.Infinite
                        easing.type: Easing.Linear
                    }

                }

            }

        }

        Column {
            height: parent.height
            width: parent.width / 2

            Rectangle {
                height: 100
                width: parent.width
                color: "#cc000000"

                AnimatedImage {
                    source: "eye.gif"
                    width: 100
                    height: 100
                    fillMode: Image.PreserveAspectFit
                }

                TextField {
                    width: parent.width - 100
                    height: 100
                    placeholderText: "Search"
                    font.family: "Hack Nerd Font Mono"
                    color: "#f4f4f4"
                    font.pointSize: 11
                    anchors.left: parent.left
                    anchors.leftMargin: 100
                    onAccepted: () => {
                        console.log("hi");
                    }

                    background: Rectangle {
                        color: "#00000000"
                        anchors.fill: parent
                    }

                }

            }

            Repeater {
                model: DesktopEntries.applications

                Rectangle {
                    required property DesktopEntry modelData

                    color: "#cc000000"
                    height: 100
                    width: parent.width

                    IconImage {
                        id: appIcon

                        implicitSize: 30
                        source: "image://icon/" + parent.modelData.icon
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                    }

                    Text {
                        font.family: "Hack Nerd Font Mono"
                        color: "#f4f4f4"
                        font.pointSize: 11
                        width: parent.width
                        wrapMode: Text.Wrap
                        text: "┌────────────────────────────────────┐\n│\n│ " + parent.modelData.name + "\n│\n└────────────────────────────────────┘\n"
                        anchors.left: appIcon.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 10
                    }

                }

            }

        }

    }

}
