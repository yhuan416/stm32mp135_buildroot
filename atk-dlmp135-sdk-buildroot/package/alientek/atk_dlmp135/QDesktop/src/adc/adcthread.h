/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         adcthread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2022-12-24
*******************************************************************/
#ifndef ADCTHREAD_H
#define ADCTHREAD_H

#include <QObject>
#include <QThread>
#include <QDebug>
#include <QFile>

class AdcThread : public QThread
{
    Q_OBJECT
public:
    AdcThread(QObject *parent = nullptr);
    ~AdcThread();
    void run() override;

    bool startThread() const;
    int value() const;
    unsigned long interval() const;

    void setStart(bool start);
    void setInterval(unsigned long interval);

    Q_PROPERTY(bool start READ startThread WRITE setStart NOTIFY startChanged)
    Q_PROPERTY(int value READ value NOTIFY valueChanged)
    Q_PROPERTY(int interval READ interval WRITE setInterval NOTIFY intervalChanged)

private:
    bool m_start = true;
    int m_value;
    unsigned long m_interval = 50;

signals:
    void startChanged();
    void valueChanged();
    void intervalChanged();
};

#endif // ADCTHREAD_H
