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
    qRegisterMetaType<Chessy::GnuChessEngine*>("Chessy::GnuChessEngine*");

    engine.load(QUrl(QStringLiteral("qrc:/QML/main.qml")));
    auto res = 0;
    try
    {
        res = app.exec();
    }
    catch (const std::exception& ex)
    {
        QMessageBox::critical(nullptr
                              , qtTrId("Error")
                              , QString::fromStdString(ex.what()));
        return 1;
    }

    return res;
}
