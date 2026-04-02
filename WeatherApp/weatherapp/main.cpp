#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "WeatherAPI.h"
#include <QtQml>
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    qmlRegisterType<WeatherAPI>("com.weather", 1, 0, "WeatherAPI");
    engine.loadFromModule("weatherapp", "Main");

    return app.exec();
}
