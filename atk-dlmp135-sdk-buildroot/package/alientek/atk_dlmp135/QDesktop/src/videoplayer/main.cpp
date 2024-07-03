/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   videoplayer
* @brief         main.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-11-22
* @link          http://www.openedv.com/forum.php
*******************************************************************/
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <QTextCodec>
#include <QDir>

int main(int argc, char *argv[])
{
    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.addImportPath(QDir::currentPath() + "/..");

    QDir::setCurrent(QCoreApplication::applicationDirPath());
    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());


    engine.load(QUrl(QStringLiteral("qrc:/VideoPlayer_Window.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
