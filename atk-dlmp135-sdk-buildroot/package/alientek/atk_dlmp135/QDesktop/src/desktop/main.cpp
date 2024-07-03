/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         main.cpp
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-28
*******************************************************************/
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QFontDatabase>
#include <QQmlContext>
#include <QWindow>
#include <QApplication>
#include <QDebug>
#include <QDir>
#include <QTextCodec>

#include "../music/lyricmodel.h"
#include "../music/playlistmodel.h"

#include "../photoview/photolistmodel.h"

#include "../fileview/fileio.h"

#include "../board/board.h"

#include "../notepad/notepadListModel.h"
#include "../notepad/filereadwrite.h"

#include "../adc/adcthread.h"

#include "../camera/cameraitem.h"

#include "../factorytest/factory.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    qputenv("QT_QPA_FB_DRM", QByteArray("1"));
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    //QGuiApplication app(argc, argv);
    QApplication app(argc, argv);

    qmlRegisterSingletonType(QUrl("qrc:/QmlEvent.qml"), "QmlEvents", 1, 0, "QmlEvents");

    qmlRegisterType<lyricModel>("dataModel", 1, 0, "LyricModel");
    qmlRegisterType<playListModel>("dataModel", 1, 0, "PlayListModel");

    qmlRegisterType<PhotoListModel>("photoListModel", 2, 0, "PhotoListModel");

    qmlRegisterType<FileIO, 1>("fileIO", 1, 0, "FileIO");

    qmlRegisterType<Board>("board", 1, 0, "Board");


    qmlRegisterType<NotepadListModel>("notepadModel", 1, 0, "NotepadListModel");

    qmlRegisterType<FileReadWrite>("fileReadWrite", 1, 0, "FileReadWrite");

    qmlRegisterType<AdcThread>("adcthread", 1, 0, "AdcThread");

    qmlRegisterType<CameraItem>("cameraItem", 1, 0, "CameraItem");

    qmlRegisterType<Factory>("factory", 1, 0, "Factory");

    QDir::setCurrent(QCoreApplication::applicationDirPath());

    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));

    int fontIndex = QFontDatabase::addApplicationFont(":/fonts/Montserrat-Light.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Montserrat-Bold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Montserrat-Regular.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Montserrat-Medium.ttf");
    QStringList fontFamilies = QFontDatabase::applicationFontFamilies(fontIndex);
    qDebug()<<"fontfamilies:"<<fontFamilies;

    QFont font;
    font.setFamily("Montserrat Light");
    app.setFont(font);
    QQmlApplicationEngine engine;

    bool armEnv;
    bool linuxEnv;
#if linux
    linuxEnv = true;
#else
    linuxEnv = false;
#endif  

#if __arm__
    armEnv = true;
#else
    armEnv = false;
#endif

    engine.rootContext()->setContextProperty("armEnv", armEnv);
    engine.rootContext()->setContextProperty("linuxEnv", linuxEnv);

    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());

    engine.addImportPath(":/CustomStyle");
    qputenv("QT_VIRTUALKEYBOARD_STYLE", "greywhite");

    engine.addImportPath(QDir::currentPath() + "/..");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
