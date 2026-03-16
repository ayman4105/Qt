import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 400
    height: 500
    title: "WiFi & Bluetooth Manager"

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: homePage
    }

    Component {
        id: homePage

        Rectangle {
            color: "#1a1a2e"

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 30

                Text {
                    text: "Network Manager"
                    font.pixelSize: 28
                    font.bold: true
                    color: "white"
                    Layout.alignment: Qt.AlignHCenter
                }

                Button {
                    text: "WiFi Settings"
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 60
                    onClicked: stackView.push(wifiPage)
                }

                Button {
                    text: "Bluetooth Settings"
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 60
                    onClicked: stackView.push(bluetoothPage)
                }
            }
        }
    }

    Component {
        id: wifiPage

        Rectangle {
            color: "#1a1a2e"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                RowLayout {
                    Layout.fillWidth: true

                    Button {
                        text: "Back"
                        onClicked: stackView.pop()
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "WiFi"
                        font.pixelSize: 24
                        font.bold: true
                        color: "white"
                    }

                    Item { Layout.fillWidth: true }

                    Switch {
                        id: wifiSwitch
                        checked: wifiManager.wifienable
                        onClicked: wifiManager.wifienable = checked
                    }
                }

                Button {
                    text: "Scan Networks"
                    Layout.fillWidth: true
                    onClicked: wifiManager.scan()
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#16213e"
                    radius: 10

                    ListView {
                        id: networksList
                        anchors.fill: parent
                        anchors.margins: 10
                        model: wifiManager.networksList
                        spacing: 5
                        clip: true

                        delegate: Rectangle {
                            width: networksList.width
                            height: 60
                            color: "#0f3460"
                            radius: 8

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10

                                ColumnLayout {
                                    spacing: 2

                                    Text {
                                        text: modelData.ssid
                                        font.pixelSize: 16
                                        font.bold: true
                                        color: "white"
                                    }

                                    Text {
                                        text: "Signal: " + modelData.strength + "%"
                                        font.pixelSize: 12
                                        color: "#a0a0a0"
                                    }
                                }

                                Item { Layout.fillWidth: true }

                                Button {
                                    text: "Connect"
                                    onClicked: {
                                        passwordDialog.networkName = modelData.ssid
                                        passwordDialog.open()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: bluetoothPage

        Rectangle {
            color: "#1a1a2e"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                RowLayout {
                    Layout.fillWidth: true

                    Button {
                        text: "Back"
                        onClicked: stackView.pop()
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "Bluetooth"
                        font.pixelSize: 24
                        font.bold: true
                        color: "white"
                    }

                    Item { Layout.fillWidth: true }

                    Switch {
                        id: btSwitch
                        checked: bluetoothManager.bluetoothEnabled
                        onClicked: bluetoothManager.bluetoothEnabled = checked
                    }
                }

                Button {
                    text: bluetoothManager.scanning ? "Scanning..." : "Scan Devices"
                    Layout.fillWidth: true
                    enabled: !bluetoothManager.scanning
                    onClicked: bluetoothManager.startScan()
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#16213e"
                    radius: 10

                    ListView {
                        id: btDevicesList
                        anchors.fill: parent
                        anchors.margins: 10
                        model: bluetoothManager.devicesList
                        spacing: 5
                        clip: true

                        delegate: Rectangle {
                            width: btDevicesList.width
                            height: 70
                            color: modelData.connected ? "#1e5128" : "#0f3460"
                            radius: 8

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10

                                ColumnLayout {
                                    spacing: 2

                                    Text {
                                        text: modelData.name
                                        font.pixelSize: 16
                                        font.bold: true
                                        color: "white"
                                    }

                                    Text {
                                        text: modelData.address
                                        font.pixelSize: 12
                                        color: "#a0a0a0"
                                    }

                                    Text {
                                        text: modelData.connected ? "Connected" : (modelData.paired ? "Paired" : "Not Paired")
                                        font.pixelSize: 11
                                        color: modelData.connected ? "#90EE90" : "#a0a0a0"
                                    }
                                }

                                Item { Layout.fillWidth: true }

                                Button {
                                    text: modelData.connected ? "Disconnect" : "Connect"
                                    onClicked: {
                                        if (modelData.connected) {
                                            bluetoothManager.disconnectDevice(modelData.path)
                                        } else {
                                            bluetoothManager.connectToDevice(modelData.path)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Dialog {
        id: passwordDialog
        title: "Connect to Network"
        anchors.centerIn: parent
        modal: true

        property string networkName: ""

        ColumnLayout {
            spacing: 15

            Text {
                text: "Network: " + passwordDialog.networkName
                font.pixelSize: 14
            }

            TextField {
                id: passwordField
                placeholderText: "Enter password"
                echoMode: TextInput.Password
                Layout.preferredWidth: 250
            }

            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignRight

                Button {
                    text: "Cancel"
                    onClicked: passwordDialog.close()
                }

                Button {
                    text: "Connect"
                    onClicked: {
                        wifiManager.connectToNetwork(passwordDialog.networkName, passwordField.text)
                        passwordField.text = ""
                        passwordDialog.close()
                    }
                }
            }
        }
    }
}
