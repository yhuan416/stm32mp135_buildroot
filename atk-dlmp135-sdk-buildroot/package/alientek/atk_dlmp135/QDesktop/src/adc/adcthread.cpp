/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         adcthread.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2022-12-24
*******************************************************************/
#include "adcthread.h"

AdcThread::AdcThread(QObject *parent) : QThread (parent)
{

}

AdcThread::~AdcThread()
{
    setStart(false);
}

void AdcThread::run()
{
    QFile file;
    file.setFileName("/sys/bus/iio/devices/iio:device0/in_voltage0_raw");
    if (!file.exists()) {
        qDebug() << "ADC does not exists" << endl;
        return;
    }
    while (m_start) {
        if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            msleep(m_interval);
            QString adcValue = file.readAll();
            QStringList list = adcValue.split("\n");
            m_value = list[0].toInt();
            emit valueChanged();
        }
        file.close();
    }
}

bool AdcThread::startThread() const
{
    return  m_start;
}

int AdcThread::value() const
{
    return  m_value;
}

unsigned long AdcThread::interval() const
{
    return m_interval;
}

void AdcThread::setStart(bool start)
{

    m_start =  start;
    if (start && !this->isRunning()) {
        this->start();
    } else {
        if (this->isRunning()) {
            while (this->isRunning());
            this->wait(10);
        }
    }
}

void AdcThread::setInterval(unsigned long interval)
{
    m_interval = interval;
}
