#include "BluetoothManager.h"
#include <QDBusMessage>
#include <QDBusMetaType>
#include <QDebug>
#include <iostream>
#include <QTimer>

BluetoothManager::BluetoothManager(QObject *parent) : QObject(parent), m_scanning(false)
{
    findAdapter();
}

void BluetoothManager::findAdapter()
{
    std::cout << "=== Finding Bluetooth Adapter ===" << std::endl;

    QDBusMessage msg = QDBusMessage::createMethodCall(
        "org.bluez",
        "/",
        "org.freedesktop.DBus.ObjectManager",
        "GetManagedObjects"
        );

    QDBusMessage reply = QDBusConnection::systemBus().call(msg);

    if (reply.type() == QDBusMessage::ErrorMessage) {
        std::cout << "Error: " << reply.errorMessage().toStdString() << std::endl;
        return;
    }

    QVariant arg = reply.arguments().at(0);
    const QDBusArgument &dbusArg = arg.value<QDBusArgument>();

    dbusArg.beginMap();
    while (!dbusArg.atEnd()) {
        QString path;
        QVariantMap interfaces;

        dbusArg.beginMapEntry();
        dbusArg >> path >> interfaces;
        dbusArg.endMapEntry();

        if (interfaces.contains("org.bluez.Adapter1")) {
            m_adapterPath = path;
            std::cout << "Found adapter: " << path.toStdString() << std::endl;
            break;
        }
    }
    dbusArg.endMap();

    if (m_adapterPath.isEmpty()) {
        std::cout << "No Bluetooth adapter found!" << std::endl;
    }
}

bool BluetoothManager::bluetoothEnabled() const
{
    if (m_adapterPath.isEmpty()) return false;

    QDBusInterface adapter(
        "org.bluez",
        m_adapterPath,
        "org.bluez.Adapter1",
        QDBusConnection::systemBus()
        );

    return adapter.property("Powered").toBool();
}

void BluetoothManager::setBluetoothEnabled(bool enabled)
{
    if (m_adapterPath.isEmpty()) return;

    QDBusInterface adapter(
        "org.bluez",
        m_adapterPath,
        "org.freedesktop.DBus.Properties",
        QDBusConnection::systemBus()
        );

    adapter.call("Set", "org.bluez.Adapter1", "Powered", QVariant::fromValue(QDBusVariant(enabled)));
    emit bluetoothEnabledChanged();
}

bool BluetoothManager::scanning() const
{
    return m_scanning;
}

QVariantList BluetoothManager::devicesList() const
{
    return m_devicesList;
}

void BluetoothManager::startScan()
{
    if (m_adapterPath.isEmpty()) {
        std::cout << "No adapter!" << std::endl;
        return;
    }

    std::cout << "=== Starting Bluetooth Scan ===" << std::endl;

    QDBusInterface adapter(
        "org.bluez",
        m_adapterPath,
        "org.bluez.Adapter1",
        QDBusConnection::systemBus()
        );

    adapter.call("StartDiscovery");
    m_scanning = true;
    emit scanningChanged();

    QTimer::singleShot(3000, this, [this]() {
        loadDevices();
    });
}

void BluetoothManager::stopScan()
{
    if (m_adapterPath.isEmpty()) return;

    QDBusInterface adapter(
        "org.bluez",
        m_adapterPath,
        "org.bluez.Adapter1",
        QDBusConnection::systemBus()
        );

    adapter.call("StopDiscovery");
    m_scanning = false;
    emit scanningChanged();
}

void BluetoothManager::loadDevices()
{
    std::cout << "=== Loading Bluetooth Devices ===" << std::endl;

    m_devicesList.clear();

    QDBusMessage msg = QDBusMessage::createMethodCall(
        "org.bluez",
        "/",
        "org.freedesktop.DBus.ObjectManager",
        "GetManagedObjects"
        );

    QDBusMessage reply = QDBusConnection::systemBus().call(msg);

    if (reply.type() == QDBusMessage::ErrorMessage) {
        std::cout << "Error: " << reply.errorMessage().toStdString() << std::endl;
        return;
    }

    QVariant arg = reply.arguments().at(0);
    const QDBusArgument &dbusArg = arg.value<QDBusArgument>();

    dbusArg.beginMap();
    while (!dbusArg.atEnd()) {
        QString path;
        QVariantMap interfaces;

        dbusArg.beginMapEntry();
        dbusArg >> path >> interfaces;
        dbusArg.endMapEntry();

        if (interfaces.contains("org.bluez.Device1")) {
            QDBusInterface device(
                "org.bluez",
                path,
                "org.bluez.Device1",
                QDBusConnection::systemBus()
                );

            QString name = device.property("Name").toString();
            QString address = device.property("Address").toString();
            bool connected = device.property("Connected").toBool();
            bool paired = device.property("Paired").toBool();

            if (name.isEmpty()) {
                name = address;
            }

            std::cout << "Device: " << name.toStdString() << " Connected: " << connected << std::endl;

            QVariantMap deviceInfo;
            deviceInfo["name"] = name;
            deviceInfo["address"] = address;
            deviceInfo["path"] = path;
            deviceInfo["connected"] = connected;
            deviceInfo["paired"] = paired;

            m_devicesList.append(deviceInfo);
        }
    }
    dbusArg.endMap();

    std::cout << "Total devices: " << m_devicesList.size() << std::endl;
    emit devicesListChanged();
}

void BluetoothManager::connectToDevice(const QString &path)
{
    std::cout << "Connecting to: " << path.toStdString() << std::endl;

    QDBusInterface device(
        "org.bluez",
        path,
        "org.bluez.Device1",
        QDBusConnection::systemBus()
        );

    device.call("Connect");
    loadDevices();
}

void BluetoothManager::disconnectDevice(const QString &path)
{
    std::cout << "Disconnecting: " << path.toStdString() << std::endl;

    QDBusInterface device(
        "org.bluez",
        path,
        "org.bluez.Device1",
        QDBusConnection::systemBus()
        );

    device.call("Disconnect");
    loadDevices();
}

void BluetoothManager::pairDevice(const QString &path)
{
    std::cout << "Pairing: " << path.toStdString() << std::endl;

    QDBusInterface device(
        "org.bluez",
        path,
        "org.bluez.Device1",
        QDBusConnection::systemBus()
        );

    device.call("Pair");
    loadDevices();
}
