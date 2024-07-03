#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTextCodec>
#include <QDir>

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.addImportPath(QDir::currentPath() + "/..");
    engine.addImportPath(":/CustomStyle");
    qputenv("QT_VIRTUALKEYBOARD_STYLE", "greywhite");
    engine.load(QUrl(QStringLiteral("qrc:/Wifi_Window.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
