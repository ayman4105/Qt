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








