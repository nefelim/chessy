#include "pch.h"
#include "GnuChessEngine.h"

Chessy::GnuChessEngine::GnuChessEngine(QObject * parent/* = nullptr*/)
    : QObject(parent)
    , m_gnuChessProcess(this)
    , m_boardState("")
{
    connect(&m_gnuChessProcess, SIGNAL(readyRead()), this, SLOT(gnuchessReadyRead()));
}

bool Chessy::GnuChessEngine::newGame()
{
    if (m_gnuChessProcess.state() ==QProcess::Running)
    {
        m_gnuChessProcess.terminate();
        m_gnuChessProcess.waitForFinished(1000);
    }
    QProcessEnvironment env;
    env.insert("LANG", "C");
    m_gnuChessProcess.setProcessEnvironment(env);
    m_gnuChessProcess.start("gnuchess", QIODevice::ReadWrite);
    if(!m_gnuChessProcess.waitForStarted(10000))
    {
        emit message(tr("Can't run gnuchess! Please install it"));
        return false;
    }
    //sendCommand("new");
    sendCommand("show board");

    return true;
}

void Chessy::GnuChessEngine::gnuchessReadyRead()
{
    while(m_gnuChessProcess.bytesAvailable() > 0)
    {
        QString line = m_gnuChessProcess.readLine();
        qDebug() << line;

        if(line.indexOf("Illegal move:") == 0)
        {
            emit message(tr("Illegal move!"));
        }

        if(line.indexOf("White (") == 0)
        {
            emit refresh();
        }

        if(line.indexOf("wins") >= 0)
        {
            emit gameOver(tr("You win!"));
            break;
        }

        if(line.indexOf("looses") >= 0)
        {
            emit gameOver(tr("You looses!"));
            break;
        }

        if (line.indexOf("draw") >= 0)
        {
            emit gameOver(tr("Draw!"));
            break;
        }

        if(line.indexOf("black") == 0
           || line.indexOf("white") == 0)
        {
            m_newBoardState.clear();
        }

        QRegExp rx("[\\.RNBQKPrnbqkp] [\\.RNBQKPrnbqkp] [\\.RNBQKPrnbqkp] [\\.RNBQKPrnbqkp] [\\.RNBQKPrnbqkp] [\\.RNBQKPrnbqkp] [\\.RNBQKPrnbqkp] [\\.RNBQKPrnbqkp]");
        int pos = rx.indexIn(line);
        if(pos < 0)
        {
            continue;
        }
        line.remove(' ');
        line.remove('\n');
        m_newBoardState.append(line);
    }
    if (m_newBoardState.size() >= 64)
    {
        m_boardState = m_newBoardState;
        m_newBoardState.clear();
        emit refresh();
    }
}

void Chessy::GnuChessEngine::sendCommand(const QString& cmd)
{
    qDebug() << cmd;
    m_gnuChessProcess.write(cmd.toUtf8());
    m_gnuChessProcess.write("\n");
    gnuchessReadyRead();
}
