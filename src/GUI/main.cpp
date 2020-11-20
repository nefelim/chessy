#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QMessageBox>

#include "ContextProvider.h"

int main(int argc, char** argv)
{
    QApplication app(argc, argv);

    ContextProvider contextProvider;
    QQmlApplicationEngine engine;
    auto ctx = engine.rootContext();
    ctx->setContextProperty("contextProvider", &contextProvider);

    qRegisterMetaType<Chessy::GnuChessEngine*>("Chessy::GnuChessEngine*"); // Q_DECLARE_METATYPE ???

    engine.load("qrc:/QML/main.qml");
    return app.exec();
}
