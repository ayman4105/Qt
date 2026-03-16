import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480
    title: "LED Control"
    color: ledController.ledOn ? "#1a1a2e" : "#0f0f0f"

    // Smooth background color transition
    Behavior on color {
        ColorAnimation { duration: 300 }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 30

        // Title
        Text {
            text: "LED Control Panel"
            font.pixelSize: 28
            font.bold: true
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }

        // LED indicator circle
        Rectangle {
            id: ledIndicator
            width: 100
            height: 100
            radius: 50
            Layout.alignment: Qt.AlignHCenter

            color: ledController.ledOn ? "#00ff00" : "#333333"
            border.color: ledController.ledOn ? "#00ff00" : "#555555"
            border.width: 3

            Behavior on color {
                ColorAnimation { duration: 200 }
            }

            // Glow effect when LED is on
            Rectangle {
                anchors.centerIn: parent
                width: parent.width + 20
                height: parent.height + 20
                radius: width / 2
                color: "transparent"
                border.color: ledController.ledOn ? "#00ff0055" : "transparent"
                border.width: 10
                visible: ledController.ledOn
            }

            // ON/OFF label inside the circle
            Text {
                anchors.centerIn: parent
                text: ledController.ledOn ? "ON" : "OFF"
                font.pixelSize: 20
                font.bold: true
                color: ledController.ledOn ? "black" : "#888888"
            }
        }

        // Switch row
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 15

            Text {
                text: "OFF"
                font.pixelSize: 18
                color: ledController.ledOn ? "#888888" : "white"
            }

            Switch {
                id: ledSwitch
                checked: ledController.ledOn

                onCheckedChanged: {
                    ledController.ledOn = checked
                }

                // Custom switch style
                indicator: Rectangle {
                    implicitWidth: 80
                    implicitHeight: 40
                    radius: 20
                    color: ledSwitch.checked ? "#00cc00" : "#555555"
                    border.color: ledSwitch.checked ? "#00ff00" : "#777777"

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }

                    // The sliding knob
                    Rectangle {
                        x: ledSwitch.checked ? parent.width - width - 4 : 4
                        anchors.verticalCenter: parent.verticalCenter
                        width: 32
                        height: 32
                        radius: 16
                        color: "white"

                        Behavior on x {
                            NumberAnimation { duration: 200 }
                        }
                    }
                }
            }

            Text {
                text: "ON"
                font.pixelSize: 18
                color: ledController.ledOn ? "white" : "#888888"
            }
        }

        // Action buttons row
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 15

            // ON button
            Button {
                text: "ON"
                font.pixelSize: 16
                implicitWidth: 100
                implicitHeight: 45

                background: Rectangle {
                    color: parent.pressed ? "#006600" : "#008800"
                    radius: 10
                }

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    ledController.turnOn()
                    ledSwitch.checked = true
                }
            }

            // Toggle button
            Button {
                text: "Toggle"
                font.pixelSize: 16
                implicitWidth: 100
                implicitHeight: 45

                background: Rectangle {
                    color: parent.pressed ? "#cc8800" : "#ff9900"
                    radius: 10
                }

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    ledController.toggle()
                    ledSwitch.checked = ledController.ledOn
                }
            }

            // OFF button
            Button {
                text: "OFF"
                font.pixelSize: 16
                implicitWidth: 100
                implicitHeight: 45

                background: Rectangle {
                    color: parent.pressed ? "#660000" : "#cc0000"
                    radius: 10
                }

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    ledController.turnOff()
                    ledSwitch.checked = false
                }
            }
        }

        // Status text at the bottom
        Text {
            text: "Pin: GPIO 27 | Status: " + (ledController.ledOn ? "Active" : "Inactive")
            font.pixelSize: 14
            color: "#aaaaaa"
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
