import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
    id: mainWindow
    width: 800
    height: 600
    visible: true
    title: qsTr("Hello Client")

    x: 300
    y: 100

    property bool showSplash: true
    property int temperature: 18

    // Gallery properties
    property int currentIndex: 0
    property var images: [
        "qrc:/Pasted image1.png",
        "qrc:/Pasted image2.png",
        "qrc:/Pasted image3.png",
        "qrc:/Pasted image4.png"
    ]

    // Splash Timer
    Timer {
        interval: 3000
        running: true
        repeat: false
        onTriggered: showSplash = false
    }

    // Splash Screen
    Rectangle {
        anchors.fill: parent
        visible: showSplash
        z: 1

        Image {
            anchors.fill: parent
            source: "qrc:/Pasted image.png"
            fillMode: Image.PreserveAspectCrop
        }
    }

    // Main Screen
    Rectangle {
        anchors.fill: parent
        color: "white"
        visible: !showSplash

        // App Name
        Text {
            text: "Gallery"
            font.pointSize: parent.width / 20
            font.bold: true
            color: "navy"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
        }

        // Date + Temperature
        Column {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 10
            spacing: 5

            Text {
                font.pixelSize: 20
                color: "black"
                text: Qt.formatDate(new Date(), "dddd, MMMM d yyyy")
            }

            Text {
                text: "Temperature: " + temperature + "°C"
                font.pixelSize: 20
                color: "black"
            }
        }

        // Time
        Column {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 10

            Text {
                id: timeText
                font.pixelSize: 20
                color: "black"
                text: Qt.formatTime(new Date(), "hh:mm:ss AP")
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: timeText.text =
                             Qt.formatTime(new Date(), "hh:mm:ss AP")
            }
        }

        // Gallery Image
        Image {
            id: galleryImage
            anchors.centerIn: parent
            width: parent.width * 0.6
            height: parent.height * 0.5
            fillMode: Image.PreserveAspectFit
            source: images[currentIndex]
        }

        // Navigation Buttons
        Row {
            id: navigationRow
            spacing: 20
            anchors.top: galleryImage.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20

            // Previous Button
            Rectangle {
                width: 120
                height: 40
                color: "lightgray"
                radius: 8

                Text {
                    anchors.centerIn: parent
                    text: "Previous"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        currentIndex =
                            (currentIndex - 1 + images.length) % images.length
                    }
                }
            }

            // Next Button
            Rectangle {
                width: 120
                height: 40
                color: "lightgray"
                radius: 8

                Text {
                    anchors.centerIn: parent
                    text: "Next"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        currentIndex =
                            (currentIndex + 1) % images.length
                    }
                }
            }
        }

        // Info Button
        Rectangle {
            width: 120
            height: 40
            color: "#d0e6ff"
            radius: 8

            anchors.top: navigationRow.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 15

            Text {
                anchors.centerIn: parent
                text: "Info"
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: infoWindow.show()
            }
        }
    }

    // =========================
    // Info Window
    // =========================
    Window {
        id: infoWindow
        width: 800
        height: 350
        visible: false
        title: "About This Project"

        // Center on screen
        x: (Screen.width - width) / 2
        y: (Screen.height - height) / 2

        Rectangle {
            anchors.fill: parent
            color: "white"

            Column {
                anchors.centerIn: parent
                width: parent.width * 0.8
                spacing: 15

                Text {
                    text: "Gallery Application"
                    font.pixelSize: 24
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                }

                Text {
                    wrapMode: Text.WordWrap
                    text: "my gallery"

                }
            }
        }
    }
}
