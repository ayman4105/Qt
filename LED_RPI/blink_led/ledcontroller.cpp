#include "ledcontroller.h"
#include <QDebug>

LedController::LedController(QObject *parent)
    : QObject(parent),
    m_ledOn(false),
    m_led(nullptr)
{
    // Create GPIO pin 27 as output
    m_led = new gpio_pin(27, gpio_out);

    // Start with LED off
    m_led->write_value(0);

    qDebug() << "LED Controller initialized on pin 27";
}

LedController::~LedController()
{
    if (m_led) {
        // Turn off LED before cleanup
        m_led->write_value(0);
        delete m_led;
        m_led = nullptr;
    }
    qDebug() << "LED Controller destroyed";
}

bool LedController::ledOn() const
{
    return m_ledOn;
}

void LedController::setLedOn(bool on)
{
    // Skip if state hasn't changed
    if (m_ledOn == on)
        return;

    m_ledOn = on;

    // Write to hardware
    if (m_led) {
        m_led->write_value(on ? 1 : 0);
    }

    qDebug() << "LED is now:" << (on ? "ON" : "OFF");

    // Notify QML that the property changed
    emit ledOnChanged();
}

void LedController::toggle()
{
    setLedOn(!m_ledOn);
}

void LedController::turnOn()
{
    setLedOn(true);
}

void LedController::turnOff()
{
    setLedOn(false);
}
