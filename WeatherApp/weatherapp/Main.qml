import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import com.weather 1.0

Window {
    id: root
    width: 740
    height: 620
    visible: true
    title: "Weather App"
    minimumWidth: 350
    minimumHeight: 600

    WeatherAPI {
        id: weatherApi
    }

    Connections {
        target: weatherApi
        function onForecastReady() {
            forecastList.model = weatherApi.forecast
        }
    }

    // Background
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#4776E6" }
            GradientStop { position: 1.0; color: "#8E54E9" }
        }
    }

    // Scrollable Content
    Flickable {
        anchors.fill: parent
        contentHeight: mainColumn.height + 40
        clip: true

        ColumnLayout {
            id: mainColumn
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 20
            spacing: 15

            Item { height: 10 }

            // Search Bar
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                height: 55
                radius: 27
                color: Qt.rgba(255, 255, 255, 0.25)

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 10
                    spacing: 10

                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        placeholderText: "Enter city name..."
                        placeholderTextColor: Qt.rgba(1, 1, 1, 0.6)
                        color: "white"
                        font.pixelSize: 16
                        background: Rectangle { color: "transparent" }

                        Keys.onReturnPressed: {
                            if (text !== "") {
                                weatherApi.fetchWeather(text)
                            }
                        }
                    }

                    Rectangle {
                        width: 45
                        height: 45
                        radius: 22
                        color: "white"

                        Text {
                            anchors.centerIn: parent
                            text: "🔍"
                            font.pixelSize: 20
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (searchField.text !== "") {
                                    weatherApi.fetchWeather(searchField.text)
                                }
                            }
                        }
                    }
                }
            }

            Item { height: 10 }

            // City Name
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: weatherApi.cityName || "Search for a city"
                font.pixelSize: 32
                font.bold: true
                color: "white"
            }

            // Temperature
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: weatherApi.temperature ? Math.round(weatherApi.temperature) + "°C" : "--°C"
                font.pixelSize: 80
                font.weight: Font.Light
                color: "white"
            }

            // Weather Description
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: weatherApi.weather || ""
                font.pixelSize: 24
                color: Qt.rgba(1, 1, 1, 0.9)
                font.capitalization: Font.Capitalize
                visible: weatherApi.weather ? true : false
            }

            Item { height: 10 }

            // Weather Details
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                height: 100
                radius: 20
                color: Qt.rgba(255, 255, 255, 0.2)
                visible: weatherApi.cityName ? true : false

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "💧"
                            font.pixelSize: 30
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: weatherApi.humidity + "%"
                            font.pixelSize: 20
                            font.bold: true
                            color: "white"
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Humidity"
                            font.pixelSize: 14
                            color: Qt.rgba(1, 1, 1, 0.7)
                        }
                    }

                    Rectangle {
                        width: 1
                        height: 60
                        color: Qt.rgba(1, 1, 1, 0.3)
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 5

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "💨"
                            font.pixelSize: 30
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: weatherApi.windSpeed ? weatherApi.windSpeed.toFixed(1) + " m/s" : "-- m/s"
                            font.pixelSize: 20
                            font.bold: true
                            color: "white"
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Wind"
                            font.pixelSize: 14
                            color: Qt.rgba(1, 1, 1, 0.7)
                        }
                    }
                }
            }

            Item { height: 10 }

            // Forecast Section
            Text {
                Layout.leftMargin: 20
                text: "5-Day Forecast"
                font.pixelSize: 22
                font.bold: true
                color: "white"
                visible: forecastList.count > 0
            }

            // Forecast List
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                height: forecastList.count * 70 + 20
                radius: 20
                color: Qt.rgba(255, 255, 255, 0.2)
                visible: forecastList.count > 0

                ListView {
                    id: forecastList
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8
                    clip: true
                    interactive: false
                    model: []

                    delegate: Rectangle {
                        width: forecastList.width
                        height: 58
                        radius: 15
                        color: Qt.rgba(255, 255, 255, 0.15)

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 15
                            anchors.rightMargin: 15

                            Text {
                                Layout.preferredWidth: 50
                                text: modelData.dayName || ""
                                font.pixelSize: 16
                                font.bold: true
                                color: "white"
                            }

                            Image {
                                Layout.preferredWidth: 50
                                Layout.preferredHeight: 50
                                source: modelData.icon ? "https://openweathermap.org/img/wn/" + modelData.icon + "@2x.png" : ""
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                Layout.fillWidth: true
                                text: modelData.weather || ""
                                font.pixelSize: 14
                                color: Qt.rgba(1, 1, 1, 0.85)
                                font.capitalization: Font.Capitalize
                                elide: Text.ElideRight
                            }

                            Text {
                                text: modelData.temp ? Math.round(modelData.temp) + "°" : ""
                                font.pixelSize: 22
                                font.bold: true
                                color: "white"
                            }
                        }
                    }
                }
            }

            Item { height: 20 }
        }
    }
}
