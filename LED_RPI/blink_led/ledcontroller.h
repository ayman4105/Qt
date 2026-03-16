#pragma once

#include <QObject>
#include "gpio_27.h"

// This class is the bridge between QML UI and the GPIO hardware
class LedController : public QObject
{
    Q_OBJECT

    // This property is accessible from QML
    Q_PROPERTY(bool ledOn READ ledOn WRITE setLedOn NOTIFY ledOnChanged)

public:
    explicit LedController(QObject *parent = nullptr);
    ~LedController();

    bool ledOn() const;
    void setLedOn(bool on);

signals:
    void ledOnChanged();

    // These slots can be called directly from QML
public slots:
    void toggle();
    void turnOn();
    void turnOff();

private:
    bool m_ledOn;
    gpio_pin *m_led;
};
