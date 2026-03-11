import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtMultimedia

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

    property int currentIndex: 0
    property var images: [
        "qrc:/Pasted image1.png",
        "qrc:/Pasted image2.png",
        "qrc:/Pasted image3.png",
        "qrc:/Pasted image4.png"
    ]

    // Rocket Information
    property var rocketNames: [
        "Falcon 9",
        "Saturn V",
        "Space Shuttle",
        "Starship"
    ]

    property var rocketInfo: [
        "Falcon 9 is a reusable rocket developed by SpaceX.\n\nHeight: 70 meters\nDiameter: 3.7 meters\nPayload to LEO: 22,800 kg\nFirst Flight: June 4, 2010\nStatus: Active",

        "Saturn V was a super heavy-lift launch vehicle used by NASA.\n\nHeight: 110.6 meters\nDiameter: 10.1 meters\nPayload to LEO: 140,000 kg\nFirst Flight: November 9, 1967\nStatus: Retired",

        "Space Shuttle was a partially reusable orbital spacecraft.\n\nHeight: 56.1 meters\nDiameter: 8.7 meters\nPayload to LEO: 27,500 kg\nFirst Flight: April 12, 1981\nStatus: Retired",

        "Starship is a fully reusable spacecraft by SpaceX.\n\nHeight: 120 meters\nDiameter: 9 meters\nPayload to LEO: 150,000 kg\nFirst Flight: April 20, 2023\nStatus: In Development"
    ]

    // Main Item for Focus
    Item {
        id: mainItem
        anchors.fill: parent
        focus: true

        Keys.onLeftPressed: {
            if (!showSplash) {
                currentIndex = (currentIndex - 1 + images.length) % images.length
            }
        }
        Keys.onRightPressed: {
            if (!showSplash) {
                currentIndex = (currentIndex + 1) % images.length
            }
        }

        // Splash Screen with Video
        Rectangle {
            anchors.fill: parent
            visible: showSplash
            z: 1
            color: "black"

            Video {
                id: splashVideo
                anchors.fill: parent
                source: "qrc:/untitled.mp4"
                fillMode: VideoOutput.PreserveAspectCrop
                autoPlay: true
                loops: 1
            }

            Timer {
                interval: 8000
                running: true
                repeat: false
                onTriggered: {
                    splashVideo.stop()
                    showSplash = false
                }
            }
            // skip bottom
            Rectangle {
                width: 100
                height: 40
                color: "#80000000"
                radius: 8
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 20

                Text {
                    anchors.centerIn: parent
                    text: "Skip"
                    color: "white"
                    font.pixelSize: 16
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        splashVideo.stop()
                        showSplash = false
                    }
                }
            }
        }

        // Main Screen
        Rectangle {
            anchors.fill: parent
            color: "#8B0000"
            visible: !showSplash

            // Header Bar
            Rectangle {
                id: headerBar
                width: parent.width
                height: 80
                color: "#5C0000"
                anchors.top: parent.top

                Rectangle {
                    width: parent.width
                    height: 2
                    color: "#FFD700"
                    anchors.bottom: parent.bottom
                }

                Text {
                    text: "Gallery"
                    font.pointSize: 24
                    font.bold: true
                    color: "#FFD700"
                    anchors.centerIn: parent
                }

                Column {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 15
                    spacing: 5

                    Text {
                        font.pixelSize: 14
                        color: "white"
                        text: Qt.formatDate(new Date(), "dddd, MMMM d yyyy")
                    }

                    Text {
                        text: "Temperature: " + temperature + " C"
                        font.pixelSize: 14
                        color: "white"
                    }
                }

                Text {
                    id: timeText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 15
                    font.pixelSize: 18
                    font.bold: true
                    color: "white"
                    text: Qt.formatTime(new Date(), "hh:mm:ss AP")

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: timeText.text = Qt.formatTime(new Date(), "hh:mm:ss AP")
                    }
                }
            }

            // Content Area
            Rectangle {
                id: contentArea
                anchors.top: headerBar.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                color: "transparent"

                // Image Frame
                Rectangle {
                    id: imageFrame
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -30
                    width: parent.width * 0.65
                    height: parent.height * 0.6
                    color: "#2C0000"
                    radius: 15
                    border.color: "#FFD700"
                    border.width: 3

                    Image {
                        id: galleryImage
                        anchors.fill: parent
                        anchors.margins: 10
                        fillMode: Image.PreserveAspectFit
                        source: images[currentIndex]

                        Behavior on source {
                            SequentialAnimation {
                                NumberAnimation {
                                    target: galleryImage
                                    property: "opacity"
                                    to: 0
                                    duration: 150
                                }
                                NumberAnimation {
                                    target: galleryImage
                                    property: "opacity"
                                    to: 1
                                    duration: 150
                                }
                            }
                        }
                    }

                    // Click on Image to show Rocket Info
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            rocketInfoWindow.show()
                        }
                    }

                    // Hint Text
                    Rectangle {
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: -12
                        width: 150
                        height: 24
                        color: "#5C0000"
                        radius: 12
                        border.color: "#FFD700"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Click for details"
                            color: "white"
                            font.pixelSize: 11
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottomMargin: -15
                        width: 80
                        height: 30
                        color: "#5C0000"
                        radius: 15
                        border.color: "#FFD700"
                        border.width: 2

                        Text {
                            anchors.centerIn: parent
                            text: (currentIndex + 1) + " / " + images.length
                            color: "white"
                            font.pixelSize: 14
                            font.bold: true
                        }
                    }
                }

                // Navigation Buttons
                Row {
                    id: navigationRow
                    spacing: 30
                    anchors.top: imageFrame.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 40

                    Rectangle {
                        width: 130
                        height: 45
                        color: mouseAreaPrev.pressed ? "#3C0000" : "#5C0000"
                        radius: 10
                        border.color: "#FFD700"
                        border.width: 2

                        Text {
                            anchors.centerIn: parent
                            text: "Previous"
                            color: "white"
                            font.pixelSize: 16
                            font.bold: true
                        }

                        MouseArea {
                            id: mouseAreaPrev
                            anchors.fill: parent
                            onClicked: {
                                currentIndex = (currentIndex - 1 + images.length) % images.length
                            }
                        }
                    }

                    Rectangle {
                        width: 130
                        height: 45
                        color: mouseAreaNext.pressed ? "#3C0000" : "#5C0000"
                        radius: 10
                        border.color: "#FFD700"
                        border.width: 2

                        Text {
                            anchors.centerIn: parent
                            text: "Next"
                            color: "white"
                            font.pixelSize: 16
                            font.bold: true
                        }

                        MouseArea {
                            id: mouseAreaNext
                            anchors.fill: parent
                            onClicked: {
                                currentIndex = (currentIndex + 1) % images.length
                            }
                        }
                    }
                }

                Rectangle {
                    width: 130
                    height: 45
                    color: mouseAreaInfo.pressed ? "#3C0000" : "#5C0000"
                    radius: 10
                    border.color: "#FFD700"
                    border.width: 2

                    anchors.top: navigationRow.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 20

                    Text {
                        anchors.centerIn: parent
                        text: "Info"
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                    }

                    MouseArea {
                        id: mouseAreaInfo
                        anchors.fill: parent
                        onClicked: infoWindow.show()
                    }
                }

                // Dots Indicator
                Row {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: 20
                    spacing: 10

                    Repeater {
                        model: images.length

                        Rectangle {
                            width: currentIndex === index ? 25 : 12
                            height: 12
                            radius: 6
                            color: currentIndex === index ? "#FFD700" : "#5C0000"
                            border.color: "#FFD700"
                            border.width: 1

                            Behavior on width {
                                NumberAnimation { duration: 200 }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: currentIndex = index
                            }
                        }
                    }
                }
            }
        }
    }

    // Rocket Info Window
    Window {
        id: rocketInfoWindow
        width: 550
        height: 450
        visible: false
        title: rocketNames[currentIndex]

        x: (Screen.width - width) / 2
        y: (Screen.height - height) / 2

        Rectangle {
            anchors.fill: parent
            color: "#8B0000"

            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                // Rocket Name
                Text {
                    text: rocketNames[currentIndex]
                    font.pixelSize: 32
                    font.bold: true
                    color: "#FFD700"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                }

                Rectangle {
                    width: parent.width
                    height: 2
                    color: "#FFD700"
                }

                // Rocket Image
                Rectangle {
                    width: parent.width
                    height: 150
                    color: "#2C0000"
                    radius: 10
                    border.color: "#FFD700"
                    border.width: 2

                    Image {
                        anchors.fill: parent
                        anchors.margins: 10
                        source: images[currentIndex]
                        fillMode: Image.PreserveAspectFit
                    }
                }

                // Rocket Details
                Rectangle {
                    width: parent.width
                    height: 150
                    color: "#2C0000"
                    radius: 10
                    border.color: "#FFD700"
                    border.width: 2

                    Text {
                        anchors.fill: parent
                        anchors.margins: 15
                        wrapMode: Text.WordWrap
                        text: rocketInfo[currentIndex]
                        color: "white"
                        font.pixelSize: 13
                        lineHeight: 1.4
                    }
                }

                // Close Button
                Rectangle {
                    width: 120
                    height: 30
                    color: "#5C0000"
                    radius: 8
                    border.color: "#FFD700"
                    border.width: 2
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "Close"
                        color: "white"
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: rocketInfoWindow.close()
                    }
                }
            }
        }
    }

    // Info Window
    Window {
        id: infoWindow
        width: 500
        height: 350
        visible: false
        title: "About This Project"

        x: (Screen.width - width) / 2
        y: (Screen.height - height) / 2

        Rectangle {
            anchors.fill: parent
            color: "#8B0000"

            Column {
                anchors.centerIn: parent
                width: parent.width * 0.8
                spacing: 20

                Text {
                    text: "Gallery Application"
                    font.pixelSize: 28
                    font.bold: true
                    color: "#FFD700"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                }

                Rectangle {
                    width: parent.width
                    height: 2
                    color: "#FFD700"
                }

                Text {
                    wrapMode: Text.WordWrap
                    width: parent.width
                    text: "This is a simple image gallery application developed using Qt Quick.\n\n" +
                          "Features:\n" +
                          "- Image display with easy navigation\n" +
                          "- Splash screen with video\n" +
                          "- Display time, date and temperature\n" +
                          "- Keyboard navigation support\n" +
                          "- Click on image for rocket details"
                    color: "white"
                    font.pixelSize: 14
                    lineHeight: 1.5
                }

                Rectangle {
                    width: 120
                    height: 30
                    color: "#5C0000"
                    radius: 8
                    border.color: "#FFD700"
                    border.width: 2
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "Close"
                        color: "white"
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: infoWindow.close()
                    }
                }
            }
        }
    }
}
