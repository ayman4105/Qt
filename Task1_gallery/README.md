# Qt Quick Splash Screen Explanation

## 1. Imports

```qml
import QtQuick
import QtQuick.Window
```
QtQuick provides UI elements like Rectangle, Image, and Timer.

QtQuick.Window allows using the Window element.

## main window

```qml
Window {
    width: 640
    height: 480
    visible: true
}
```
width and height define window size.

visible: true makes the window appear at startup.

## Window Positioning in Qt Quick

```qml
x:300
y:100
```
x: 300 → Sets the horizontal position of the window 300 pixels from the left edge of the screen.

y: 100 → Sets the vertical position of the window 100 pixels from the top edge of the screen.

## Splash Control Property

```qml
property bool showSplash: true
```
This Boolean property controls splash visibility.

Initially set to true so the splash appears first.

## Timer

```qml
Timer {
    interval: 3000
    running: true
    repeat: false
    onTriggered: showSplash = false
}
```
interval: 3000 → 3 seconds.

running: true → starts automatically.

repeat: false → runs only once.

After 3 seconds, splash disappears.

## Splash Layer

```qml
Rectangle {
    anchors.fill: parent
    visible: showSplash
    z: 1
}
```
Covers full window.

Visibility controlled by showSplash.

z: 1 makes it appear above other items.

## Splash Image



```qml
Image {
    anchors.fill: parent
    source: "qrc:/Pasted image.png"
    fillMode: Image.PreserveAspectCrop
}
```
Loads image from Qt Resource System.

Keeps aspect ratio without distortion.

run with clrt+r that will appear image for 3 seconds and disapeared.

notes:

the way of load image from qrc it is recommeded use it at all times 

# make main screen has app name, date , time and temperature  

## main screen for gallery

```qml
Rectangle {
           anchors.fill: parent
           color: "white"
           visible: !showSplash

// the { not closed because cont...

```
anchors.fill: parent :: Fills the entire window area with this Rectangle.

 color: "white" :: Sets the background color of the main screen to white.

 visible: !showSplash :: Shows this Rectangle only after the Splash Screen disappears.

 ## add app name 

 ```qml
           // App Name
           Text {
               text: "Gallery"
               font.pointSize: parent.width / 20
               font.bold: true
               color: "navy"
               anchors.horizontalCenter: parent.horizontalCenter
               anchors.top: parent.top
           }
```
text: "Gallery" :: Sets the text content to display the application name.

font.pointSize: parent.width / 20 :: Dynamically sets the text size based on the window width to keep it responsive.

font.bold: true :: Makes the text bold.

color: "navy" :: Sets the text color to navy.

anchors.horizontalCenter: parent.horizontalCenter :: Centers the text horizontally within the parent.
 
anchors.top: parent.top :: Anchors the text to the top of the parent.


## Date + Temperature Section

```qml
   // Date + Temperature
    property int temperature: 18
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
```
Column :: Creates a vertical layout.

All items inside it will be arranged from top to bottom.

anchors.top: parent.top :: Positions the Column at the top of its parent container.

anchors.left: parent.left :: Aligns the Column to the left side of its parent.

spacing: 5 :: Adds 5 pixels of vertical space between each child item inside the Column.

### First Text (Date)

Text :: Creates a text element to display information on the screen.

id: dateText :: Gives this Text element a unique identifier.

Allows us to access or modify it later

font.pixelSize: 20 :: Sets the font size to 20 pixels.

color: "black" :: Sets the text color to black.

text: Qt.formatDate(new Date(), "dddd, MMMM d yyyy") :: new Date() gets the current system date.

Qt.formatDate() formats the date into a readable string.

Format string:

dddd → Full day name

MMMM → Full month name

d → Day number

yyyy → Full year

##### Example output:
```
Friday, February 27, 2026
```
### Second Text (Temperature)

text: "Temperature: " + temperature + "°C" :: Displays the word "Temperature:".

Concatenates the value of the temperature property.

Adds "°C" at the end.

## Time Section

```qml
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
```

text: Qt.formatTime(new Date(), "hh:mm:ss AP") :: new Date() gets the current system time.

Qt.formatTime() formats the time into a readable string.

Format string:

hh → Hour (2 digits)

mm → Minutes

ss → Seconds

AP → AM / PM

Timer :: Creates a timer that runs in the background.

interval: 1000 :: Sets the timer interval to 1000 milliseconds.

1000 ms = 1 second.

running: true :: Starts the timer automatically when the app runs.

repeat: true :: Makes the timer repeat continuously.

Without this, it would run only once.

onTriggered: timeText.text = Qt.formatTime(new Date(), "hh:mm:ss AP") :: This code runs every time the timer triggers (every second).

It updates the timeText with the current system time.

This keeps the clock live and changing every second.
















