#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "ledcontroller.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    LedController ledController;

    QQmlApplicationEngine engine;

    // Expose C++ object to QML
    engine.rootContext()->setContextProperty("ledController", &ledController);

    // Load QML - URI is "blink_led", path is "qml/Main.qml"
    const QUrl url(u"qrc:/qt/qml/blink_led/qml/Main.qml"_qs);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
