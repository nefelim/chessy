#include "pch.h"
#include "GnuChessEngine.h"

Q_DECLARE_METATYPE(Chessy::GnuChessEngine*)

Chessy::GnuChessEngine::GnuChessEngine(QObject * parent/* = nullptr*/)
    : QObject(parent)
    , m_gnuChessProcess(this)
    , m_boardState("")
{
    newGame();
}

bool Chessy::GnuChessEngine::newGame()
{
    m_boardState = "rnbqkbnr"
                   "pppppppp"
                   "........"
                   "........"
                   "........"
                   "........"
                   "PPPPPPPP"
                   "RNBQKBNR";
    return true;
}

QString Chessy::GnuChessEngine::GetBoardState() const
{
    return m_boardState;
}
