#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "adcthread.h"
#include <QDir>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.addImportPath(QDir::currentPath() + "/..");
    qmlRegisterType<AdcThread>("adcthread", 1, 0, "AdcThread");
    engine.load(QUrl(QStringLiteral("qrc:/Adc_Window.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
