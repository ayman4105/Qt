#include "WeatherAPI.h"
#include <QNetworkRequest>
#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QDateTime>

WeatherAPI::WeatherAPI(QObject* parent) : QObject(parent) {
    manager = new QNetworkAccessManager(this);

    // Connect once in constructor
    connect(manager, &QNetworkAccessManager::finished, this, &WeatherAPI::handleNetworkReply);
}

void WeatherAPI::fetchWeather(QString cityName) {
    currentCity = cityName;
    currentRequestType = "weather";

    QString url = "https://api.openweathermap.org/data/2.5/weather?q=" + cityName + "&appid=" + apiKey + "&units=metric";

    QUrl qurl(url);
    QNetworkRequest request(qurl);
    manager->get(request);
}

void WeatherAPI::fetchForecast(QString cityName) {
    currentRequestType = "forecast";

    QString url = "https://api.openweathermap.org/data/2.5/forecast?q=" + cityName + "&appid=" + apiKey + "&units=metric";

    QUrl qurl(url);
    QNetworkRequest request(qurl);
    manager->get(request);
}

void WeatherAPI::handleNetworkReply(QNetworkReply* reply) {
    if (reply->error()) {
        qDebug() << "Error:" << reply->errorString();
        emit errorOccurred(reply->errorString());
        reply->deleteLater();
        return;
    }

    if (currentRequestType == "weather") {
        onWeatherDataReceived(reply);
    } else if (currentRequestType == "forecast") {
        onForecastReceived(reply);
    }
}

void WeatherAPI::onWeatherDataReceived(QNetworkReply* reply) {
    QByteArray data = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonObject json = doc.object();

    city_name = json.value("name").toString();

    QJsonObject main = json.value("main").toObject();
    temperature = main.value("temp").toDouble();
    humidity = main.value("humidity").toInt();

    QJsonObject wind = json.value("wind").toObject();
    windSpeed = wind.value("speed").toDouble();

    QJsonArray weatherArray = json.value("weather").toArray();
    QJsonObject weatherObj = weatherArray.at(0).toObject();
    weather = weatherObj.value("description").toString();
    icon = weatherObj.value("icon").toString();

    qDebug() << "Weather loaded:" << city_name << temperature << weather;

    emit weatherDataReady();
    reply->deleteLater();

    // Fetch forecast after weather
    fetchForecast(currentCity);
}

void WeatherAPI::onForecastReceived(QNetworkReply* reply) {
    QByteArray data = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonObject json = doc.object();

    forecastList.clear();

    QJsonArray list = json.value("list").toArray();

    QString lastDate = "";

    for (int i = 0; i < list.size(); i++) {
        QJsonObject item = list.at(i).toObject();

        QString dateTime = item.value("dt_txt").toString();
        QString date = dateTime.split(" ").at(0);

        if (date != lastDate) {
            lastDate = date;

            QJsonObject main = item.value("main").toObject();
            QJsonArray weatherArray = item.value("weather").toArray();
            QJsonObject weatherObj = weatherArray.at(0).toObject();

            QVariantMap dayForecast;
            dayForecast["date"] = date;
            dayForecast["temp"] = main.value("temp").toDouble();
            dayForecast["icon"] = weatherObj.value("icon").toString();
            dayForecast["weather"] = weatherObj.value("description").toString();

            QDateTime dt = QDateTime::fromString(dateTime, "yyyy-MM-dd hh:mm:ss");
            dayForecast["dayName"] = dt.toString("ddd");

            forecastList.append(dayForecast);

            qDebug() << "Forecast day:" << dayForecast["dayName"] << dayForecast["temp"];
        }

        if (forecastList.size() >= 5) break;
    }

    qDebug() << "Forecast loaded, days:" << forecastList.size();

    emit forecastReady();
    reply->deleteLater();
}

QString WeatherAPI::getCityName() { return city_name; }
QString WeatherAPI::getWeather() { return weather; }
int WeatherAPI::getHumidity() { return humidity; }
double WeatherAPI::getTemperature() { return temperature; }
QString WeatherAPI::getIcon() { return icon; }
double WeatherAPI::getWindSpeed() { return windSpeed; }
QVariantList WeatherAPI::getForecast() { return forecastList; }
