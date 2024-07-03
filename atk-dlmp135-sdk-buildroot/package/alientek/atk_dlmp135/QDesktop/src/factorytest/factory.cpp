/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   factorytest
* @brief         factory.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-11-09
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include "factory.h"

Factory::Factory(QObject *parent) : QObject(parent)
{
    keysThread =  new KeysThread(this);
    connect(keysThread, SIGNAL(keyDown()), this, SIGNAL(keyDown()));
    shellTest = new ShellTest(this);
    connect(shellTest, SIGNAL(readShellOutPut(QString)), this, SIGNAL(getShellTestMessage(QString)));
    connect(shellTest, SIGNAL(readShellOutPut(QString)), this, SLOT(proessResult(QString)));
}

Factory::~Factory()
{
#ifdef __arm__
    system("echo 0 > /sys/class/leds/beep/brightness");
#endif
    setThreadStart(false);
}

void Factory::setThreadStart(bool flag)
{
    keysThread->startFlag = flag;
    if (!keysThread->isRunning() && flag)
        keysThread->start();
    else {
        keysThread->quit();
        //keysThread->wait();
    }
    if (!shellTest->isRunning() && flag)
        shellTest->start();
    else {
        shellTest->killProcess();
        shellTest->quit();
    }
}

void Factory::proessResult(QString result)
{
    QStringList tmpStringList = result.split("\n");

    foreach (QString str, tmpStringList) {
        if (str.contains("Result")) {
            QStringList list = str.split("Result");
            QString tmp = list.at(1);
            emit getTestResult(tmp.simplified() + "\n");
        }
    }
}
