#pragma once
#include <QProcess>

namespace Chessy
{
    class GnuChessEngine : public QObject
    {
        Q_OBJECT
        Q_PROPERTY(QString boardState MEMBER m_boardState NOTIFY refresh)
    public:
        explicit GnuChessEngine(QObject* parent = nullptr);
        Q_INVOKABLE bool newGame();
        Q_INVOKABLE void sendCommand(const QString& cmd);

    signals:
        void refresh();
        void message(const QString& message);
        void gameOver(const QString& message);

    private slots:
        void gnuchessReadyRead();

    private:
        QProcess m_gnuChessProcess;
        QString m_boardState;
        QString m_newBoardState;
    };
}

//Q_DECLARE_METATYPE(Chessy::GnuChessEngine*) ???
