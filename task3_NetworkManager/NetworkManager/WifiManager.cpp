// Include the header file that contains the WifiManager class declaration
#include "WifiManager.h"

// Include D-Bus messaging support for communicating with system services
#include <QDBusMessage>

// Include D-Bus argument handling for parsing complex D-Bus data types
#include <QDBusArgument>

// Include Qt debugging output support (qDebug)
#include <QDebug>

#include <QProcess>

#include <iostream>


Q_DECLARE_METATYPE(QList<QDBusObjectPath>)


// ============================================================
// Constructor: Called when a WifiManager object is created
// Sets up the D-Bus connection to NetworkManager
// and finds the wireless device
// ============================================================
WifiManager::WifiManager(QObject *parent) : QObject(parent)
{

    qDBusRegisterMetaType<QList<QDBusObjectPath>>();
    // Create a D-Bus interface to communicate with NetworkManager
    // This is like opening a phone line to NetworkManager
    m_nmInterface = new QDBusInterface(
        "org.freedesktop.NetworkManager",           // Service name: who we want to talk to
        "/org/freedesktop/NetworkManager",          // Object path: which department
        "org.freedesktop.NetworkManager",           // Interface: which set of functions
        QDBusConnection::systemBus(),               // Bus type: system-level services
        this                                        // Parent: WifiManager owns this interface
        );

    // Search for the WiFi card on this device
    findWirelessDevice();
}


// ============================================================
// Getter: Returns whether WiFi is currently enabled or disabled
// Returns true if WiFi is ON, false if WiFi is OFF
// ============================================================
bool WifiManager::wifienable() const
{
    // Ask NetworkManager: "Is WiFi enabled?"
    // property() returns a QVariant, toBool() converts it to true/false
    return m_nmInterface->property("WirelessEnabled").toBool();
}


// ============================================================
// Setter: Turns WiFi ON or OFF
// enabled = true  -> Turn WiFi ON
// enabled = false -> Turn WiFi OFF
// ============================================================
void WifiManager::setWifienable(bool enabled)
{
    // Tell NetworkManager: "Set WiFi to ON/OFF"
    m_nmInterface->setProperty("WirelessEnabled", enabled);

    // Notify QML that the WiFi state has changed
    // So the UI can update itself (e.g., toggle button)
    emit wifienableChanged();
}


// ============================================================
// Getter: Returns the list of available WiFi networks
// Each network is a QVariantMap with: ssid, strength, path
// ============================================================
QVariantList WifiManager::networksList() const
{
    // Simply return the stored list of networks
    return m_networksList;
}


// ============================================================
// Private function: Finds the WiFi hardware device on this machine
// Searches through all network devices and looks for type == 2 (WiFi)
// Saves the device path in m_wirelessDevicePath for later use
// ============================================================
void WifiManager::findWirelessDevice()
{
    std::cout << "=== STARTING findWirelessDevice ===" << std::endl;

    QDBusMessage msg = QDBusMessage::createMethodCall(
        "org.freedesktop.NetworkManager",
        "/org/freedesktop/NetworkManager",
        "org.freedesktop.NetworkManager",
        "GetDevices"
        );

    QDBusMessage reply = QDBusConnection::systemBus().call(msg);

    std::cout << "Reply type: " << reply.type() << std::endl;
    std::cout << "Reply signature: " << reply.signature().toStdString() << std::endl;
    std::cout << "Arguments count: " << reply.arguments().size() << std::endl;

    if (reply.type() == QDBusMessage::ErrorMessage) {
        std::cout << "Error: " << reply.errorMessage().toStdString() << std::endl;
        return;
    }

    if (reply.arguments().isEmpty()) {
        std::cout << "No arguments!" << std::endl;
        return;
    }

    QVariant arg = reply.arguments().at(0);
    std::cout << "Argument type: " << arg.typeName() << std::endl;

    const QDBusArgument &dbusArg = arg.value<QDBusArgument>();

    QList<QDBusObjectPath> devices;
    dbusArg.beginArray();
    while (!dbusArg.atEnd()) {
        QDBusObjectPath path;
        dbusArg >> path;
        devices.append(path);
    }
    dbusArg.endArray();

    std::cout << "Total devices found: " << devices.size() << std::endl;

    for (const QDBusObjectPath &devicePath : devices) {
        std::cout << "-------------------" << std::endl;
        std::cout << "Device path: " << devicePath.path().toStdString() << std::endl;

        QDBusInterface deviceInterface(
            "org.freedesktop.NetworkManager",
            devicePath.path(),
            "org.freedesktop.NetworkManager.Device",
            QDBusConnection::systemBus()
            );

        if (!deviceInterface.isValid()) {
            std::cout << "Invalid interface!" << std::endl;
            continue;
        }

        uint deviceType = deviceInterface.property("DeviceType").toUInt();
        QString deviceName = deviceInterface.property("Interface").toString();

        std::cout << "Name: " << deviceName.toStdString() << std::endl;
        std::cout << "Type: " << deviceType << std::endl;

        if (deviceType == 2) {
            m_wirelessDevicePath = devicePath.path();
            std::cout << "SUCCESS! Found WiFi device: " << m_wirelessDevicePath.toStdString() << std::endl;
            return;
        }
    }

    std::cout << "No WiFi device with type 2 found!" << std::endl;
}


// ============================================================
// Scan: Searches for available WiFi networks around the device
// 1. Tells the WiFi card to scan
// 2. Gets the list of found access points
// 3. Reads SSID and signal strength for each one
// 4. Stores them in m_networksList
// 5. Notifies QML that the list has been updated
// ============================================================
void WifiManager::scan()
{
    std::cout << "=== STARTING scan ===" << std::endl;

    if (m_wirelessDevicePath.isEmpty()) {
        std::cout << "No wireless device found!" << std::endl;
        return;
    }

    std::cout << "Using device: " << m_wirelessDevicePath.toStdString() << std::endl;

    QDBusInterface wirelessInterface(
        "org.freedesktop.NetworkManager",
        m_wirelessDevicePath,
        "org.freedesktop.NetworkManager.Device.Wireless",
        QDBusConnection::systemBus()
        );

    wirelessInterface.call("RequestScan", QVariantMap());

    QDBusMessage msg = QDBusMessage::createMethodCall(
        "org.freedesktop.NetworkManager",
        m_wirelessDevicePath,
        "org.freedesktop.NetworkManager.Device.Wireless",
        "GetAccessPoints"
        );

    QDBusMessage reply = QDBusConnection::systemBus().call(msg);

    std::cout << "Scan reply type: " << reply.type() << std::endl;

    if (reply.type() == QDBusMessage::ErrorMessage) {
        std::cout << "Error scanning: " << reply.errorMessage().toStdString() << std::endl;
        return;
    }

    m_networksList.clear();

    QVariant arg = reply.arguments().at(0);
    const QDBusArgument &dbusArg = arg.value<QDBusArgument>();

    QList<QDBusObjectPath> accessPoints;
    dbusArg.beginArray();
    while (!dbusArg.atEnd()) {
        QDBusObjectPath path;
        dbusArg >> path;
        accessPoints.append(path);
    }
    dbusArg.endArray();

    std::cout << "Access points found: " << accessPoints.size() << std::endl;

    for (const QDBusObjectPath &apPath : accessPoints) {
        QDBusInterface apInterface(
            "org.freedesktop.NetworkManager",
            apPath.path(),
            "org.freedesktop.NetworkManager.AccessPoint",
            QDBusConnection::systemBus()
            );

        QByteArray ssidBytes = apInterface.property("Ssid").toByteArray();
        QString ssid = QString::fromUtf8(ssidBytes);
        int strength = apInterface.property("Strength").toInt();

        std::cout << "Network: " << ssid.toStdString() << " Signal: " << strength << std::endl;

        if (!ssid.isEmpty()) {
            QVariantMap network;
            network["ssid"] = ssid;
            network["strength"] = strength;
            network["path"] = apPath.path();
            m_networksList.append(network);
        }
    }

    std::cout << "Total networks added: " << m_networksList.size() << std::endl;
    emit networksListChanged();
}


void WifiManager::connectToNetwork(const QString &ssid, const QString &password)
{
    QProcess *process = new QProcess(this);

    QStringList arguments;
    arguments << "device" << "wifi" << "connect" << ssid;

    if (!password.isEmpty()) {
        arguments << "password" << password;
    }

    process->start("nmcli", arguments);

    connect(process, &QProcess::finished, this, [this, process, ssid](int exitCode) {
        if (exitCode == 0) {
            qDebug() << "Connected to:" << ssid;
        } else {
            qDebug() << "Failed to connect:" << process->readAllStandardError();
        }
        process->deleteLater();
    });
}

void WifiManager::disconnectFromNetwork()
{
    if (m_wirelessDevicePath.isEmpty()) {
        qDebug() << "No wireless device!";
        return;
    }

    QDBusInterface deviceInterface(
        "org.freedesktop.NetworkManager",
        m_wirelessDevicePath,
        "org.freedesktop.NetworkManager.Device",
        QDBusConnection::systemBus()
        );

    deviceInterface.call("Disconnect");
    qDebug() << "Disconnected from WiFi";
}
