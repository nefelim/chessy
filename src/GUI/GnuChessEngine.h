#pragma once
#include <QProcess>

namespace Chessy
{
    class GnuChessEngine : public QObject
    {
        Q_OBJECT
        Q_PROPERTY(QString boardState MEMBER m_boardState NOTIFY boardChanged)
    public:
        explicit GnuChessEngine(QObject* parent = nullptr);
        Q_INVOKABLE bool newGame();
        QString GetBoardState() const;

    signals:
        void boardChanged();

    private:
        QProcess m_gnuChessProcess;
        QString m_boardState;
    };
}
