#ifndef WEATHERAPI_H
#define WEATHERAPI_H

#include <QObject>
#include <QString>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QVariantList>

class WeatherAPI : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString cityName READ getCityName NOTIFY weatherDataReady)
    Q_PROPERTY(QString weather READ getWeather NOTIFY weatherDataReady)
    Q_PROPERTY(int humidity READ getHumidity NOTIFY weatherDataReady)
    Q_PROPERTY(double temperature READ getTemperature NOTIFY weatherDataReady)
    Q_PROPERTY(QString icon READ getIcon NOTIFY weatherDataReady)
    Q_PROPERTY(double windSpeed READ getWindSpeed NOTIFY weatherDataReady)
    Q_PROPERTY(QVariantList forecast READ getForecast NOTIFY forecastReady)

private:
    QNetworkAccessManager* manager;
    QString apiKey = "a535d6f8909944fbab017f765c2d80b1";
    QString currentCity;
    QString currentRequestType;

    QString city_name;
    QString weather;
    int humidity;
    double temperature;
    QString icon;
    double windSpeed;
    QVariantList forecastList;

public:
    explicit WeatherAPI(QObject* parent = nullptr);

    Q_INVOKABLE void fetchWeather(QString cityName);
    Q_INVOKABLE void fetchForecast(QString cityName);

    QString getCityName();
    QString getWeather();
    int getHumidity();
    double getTemperature();
    QString getIcon();
    double getWindSpeed();
    QVariantList getForecast();

private slots:
    void handleNetworkReply(QNetworkReply* reply);
    void onWeatherDataReceived(QNetworkReply* reply);
    void onForecastReceived(QNetworkReply* reply);

signals:
    void weatherDataReady();
    void forecastReady();
    void errorOccurred(QString message);
};

#endif
