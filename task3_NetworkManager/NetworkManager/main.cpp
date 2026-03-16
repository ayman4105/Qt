#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "WifiManager.h"
#include "BluetoothManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    WifiManager wifiManager;
    BluetoothManager bluetoothManager;

    engine.rootContext()->setContextProperty("wifiManager", &wifiManager);
    engine.rootContext()->setContextProperty("bluetoothManager", &bluetoothManager);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("NetworkManager", "Main");

    return app.exec();
}
