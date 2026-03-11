import QtQuick
import QtQuick.Window

Window {
    id: calc
    width: 400
    height: 500
    minimumWidth: 300
    minimumHeight: 400
    visible: true
    title: qsTr("Calculator")

    property var buttons: [
        "7", "8", "9", "÷",
        "4", "5", "6", "×",
        "1", "2", "3", "-",
        "C", "0", "=", "+"
    ]

    property string display: "0"
    signal buttonPressed(string value)

    onButtonPressed: function(value){
        if (value === "C") {
            display = "0"
        }
        else if (value === "=") {
            try {
                var expression = display.replace(/×/g, "*").replace(/÷/g, "/")

                // Check if expression is valid
                if (expression === "" ||
                    /[+\-*/]{2,}/.test(expression) ||
                    /^[+*/]/.test(expression) ||
                    /[+\-*/]$/.test(expression)) {
                    display = "Error"
                    return
                }

                var result = Function('return ' + expression)()

                // Check for division by zero or invalid result
                if (result === Infinity || result === -Infinity || isNaN(result)) {
                    display = "Error"
                } else {
                    display = result.toString()
                }
            } catch(e) {
                display = "Error"
            }
        }
        else {
            if (display === "0" || display === "Error")
                display = value
            else
                display = display + value
        }
    }

    // ============ BACKGROUND ============
    Rectangle {
        z: -1
        anchors.fill: parent
        color: "#0a1628"
    }

    // ============ SCREEN ============
    Rectangle {
        id: displayRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 15
        height: parent.height * 0.18
        radius: 15
        color: "#5cb8e4"

        Text {
            text: display
            color: "black"
            font.bold: true
            font.pixelSize: parent.height * 0.45
            font.family: "Consolas"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 20
        }
    }

    // ============ BUTTONS GRID ============
    Grid {
        id: buttonGrid
        columns: 4
        rows: 4
        spacing: 10

        anchors.top: displayRect.bottom
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter

        // Dynamic button size
        property real buttonWidth: (calc.width - 50) / 4
        property real buttonHeight: (calc.height - displayRect.height - 70) / 4

        Repeater {
            model: buttons

            Rectangle {
                width: buttonGrid.buttonWidth
                height: buttonGrid.buttonHeight
                radius: 12
                color: {
                    if (modelData === "+" || modelData === "-" || modelData === "×" || modelData === "÷")
                        return mouseArea.pressed ? "#082540" : "#0d3b66"
                    else if (modelData === "C")
                        return mouseArea.pressed ? "#0f2535" : "#1c3d5a"
                    else if (modelData === "=")
                        return mouseArea.pressed ? "#0c3448" : "#145374"
                    else
                        return mouseArea.pressed ? "#0f1a24" : "#1a2a3a"
                }

                // Shadow
                Rectangle {
                    width: parent.width
                    height: parent.height
                    radius: parent.radius
                    color: "#050a0f"
                    z: -1
                    anchors.top: parent.top
                    anchors.topMargin: 4
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                }

                Text {
                    text: modelData
                    color: "#a0d2eb"
                    font.bold: true
                    font.pixelSize: parent.height * 0.35
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        buttonPressed(modelData)
                    }
                }
            }
        }
    }
}
