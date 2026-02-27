import QtQuick
import QtQuick.Window

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("Hello Client")

    x:300
    y:100

    property bool showSplash: true
    property int temperature: 18

       Timer {
           interval: 3000
           running: true
           repeat: false
           onTriggered: showSplash = false
       }

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

           }

           // Date + Temperature
           Column {
               anchors.top: parent.top
               anchors.left: parent.left
               spacing: 5

               Text {
                   id: dateText
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
                   onTriggered: timeText.text = Qt.formatTime(new Date(), "hh:mm:ss AP")
               }
           }
       }
}
