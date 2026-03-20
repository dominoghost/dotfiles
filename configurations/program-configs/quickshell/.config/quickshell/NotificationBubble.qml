import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    // Since the panel's screen is unset, it will be picked by the compositor
    // when the window is created. Most compositors pick the current active monitor.

    anchors.bottom: true
    margins.bottom: screen.height / 5
    exclusiveZone: 0
    implicitWidth: 400
    implicitHeight: 400
    WlrLayershell.namespace: "QSNotif"
    color: "transparent"

    NotificationServer {
        id: notifServer

        onNotification: (notif) => {
            notif.tracked = true;
            console.log(trackedNotifications.values.length);
            for (var prop in notif) {
                // We wrap it in a try-catch because some native properties
                // might throw errors when accessed directly
                try {
                    console.log(prop + " : " + notif[prop]);
                } catch (e) {
                    console.log(prop + " : [unreadable]");
                }
            }
        }
    }

    Column {
        spacing: 15

        Repeater {
            model: notifServer.trackedNotifications

            Item {
                // 2. The Proxy (Prevents the "Disappearing Text" loop)
                // ShaderEffectSource {
                //     // This is why 'visible: false' works above
                //     id: effectSource
                //     sourceItem: sourceBox
                //     //live: true // Keep true if the text/source changes
                //     hideSource: true
                // }

                id: notifItem

                required property Notification modelData

                // Give the delegate a concrete size so the Column can lay it out
                width: 400
                height: 90

                // 1. The Source Item
                Rectangle {
                    id: sourceBox

                    width: parent.width
                    height: parent.height
                    color: "black"
                    visible: false // We hide this; the shader draws the version we see
                    layer.enabled: true // This helps the ShaderEffectSource capture it

                    IconImage {
                        source: notifItem.modelData.image
                        implicitSize: 50
                    }

                    Text {
                        font.family: "Hack Nerd Font Mono"
                        color: "#f4f4f4"
                        font.pointSize: 12
                        textFormat: Text.StyledText
                        anchors.centerIn: parent
                        width: 350
                        wrapMode: Text.Wrap
                        text: "<b>" + notifItem.modelData.summary + "</b><br>" + notifItem.modelData.body
                    }

                }

                // 3. The Shader
                ShaderEffect {
                    // Uniforms
                    // Point to the SOURCE, not the Box
                    property variant noiseTex
                    property real fizzleAmount: 0
                    property real time: 0
                    property variant source

                    anchors.fill: parent // Fills the delegate Item (400x35)
                    fragmentShader: "fizzle.frag.qsb"

                    source: ShaderEffectSource {
                        sourceItem: sourceBox
                        //live: true // Keep true if the text/source changes
                        hideSource: true
                    }

                    SequentialAnimation on fizzleAmount {
                        PauseAnimation {
                            duration: 2000
                        }

                        NumberAnimation {
                            from: 0
                            to: 0.05
                            duration: 1
                            easing.type: Easing.Linear
                        }

                    }

                    SequentialAnimation on opacity {
                        onStopped: notifItem.modelData.expire()

                        PauseAnimation {
                            duration: 2000
                        }

                        NumberAnimation {
                            from: 1 // Set running for testing
                            to: 0
                            duration: 300
                        }

                    }

                    // --- Animations ---
                    NumberAnimation on time {
                        id: timeAnim

                        from: 0 // Set running for testing
                        to: 1000
                        duration: 1000
                        loops: Animation.Infinite
                        easing.type: Easing.Linear
                    }

                }

            }

        }

    }

}
