#ifndef WIFIMANAGER_H
#define WIFIMANAGER_H

#include <QObject>
#include <QDBusConnection>
#include <QDBusInterface>
#include <QVariantList>
#include <QDBusReply>
 #include <QDBusObjectPath>
#include <QDBusMetaType>


class WifiManager : public QObject{
    Q_OBJECT
    Q_PROPERTY(bool wifienable READ wifienable WRITE setWifienable NOTIFY wifienableChanged FINAL)
    Q_PROPERTY(QVariantList networksList READ networksList NOTIFY networksListChanged)

private:
    QDBusInterface *m_nmInterface;
    QVariantList m_networksList;
    QString m_wirelessDevicePath;
    void findWirelessDevice();

public:
    explicit WifiManager(QObject *parent = nullptr);
    bool wifienable() const;
    void setWifienable(bool enabled);
    Q_INVOKABLE void scan();
    QVariantList networksList() const;
    Q_INVOKABLE void connectToNetwork(const QString &ssid,const QString &password);
    Q_INVOKABLE void disconnectFromNetwork();


signals:
    void wifienableChanged();
    void networksListChanged();
};



#endif // WIFIMANAGER_H
