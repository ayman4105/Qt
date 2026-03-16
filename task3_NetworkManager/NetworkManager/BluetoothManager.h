#ifndef BLUETOOTHMANAGER_H
#define BLUETOOTHMANAGER_H

#include <QObject>
#include <QDBusConnection>
#include <QDBusInterface>
#include <QVariantList>
#include <QDBusObjectPath>
#include <QDBusArgument>

class BluetoothManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool bluetoothEnabled READ bluetoothEnabled WRITE setBluetoothEnabled NOTIFY bluetoothEnabledChanged)
    Q_PROPERTY(bool scanning READ scanning NOTIFY scanningChanged)
    Q_PROPERTY(QVariantList devicesList READ devicesList NOTIFY devicesListChanged)

public:
    explicit BluetoothManager(QObject *parent = nullptr);

    bool bluetoothEnabled() const;
    void setBluetoothEnabled(bool enabled);

    bool scanning() const;

    QVariantList devicesList() const;

    Q_INVOKABLE void startScan();
    Q_INVOKABLE void stopScan();
    Q_INVOKABLE void connectToDevice(const QString &path);
    Q_INVOKABLE void disconnectDevice(const QString &path);
    Q_INVOKABLE void pairDevice(const QString &path);

signals:
    void bluetoothEnabledChanged();
    void scanningChanged();
    void devicesListChanged();

private:
    QString m_adapterPath;
    QVariantList m_devicesList;
    bool m_scanning;

    void findAdapter();
    void loadDevices();
};

#endif // BLUETOOTHMANAGER_H
