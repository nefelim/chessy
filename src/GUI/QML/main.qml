import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.2
import "Constants.js" as Constants

ApplicationWindow
{
    id: mainWindow
    title: qsTr("Chessy")
    visible: true
    width: Constants.APP_MINIMUM_WIDTH
    height: Constants.APP_MINIMUM_HEIGHT
    minimumWidth: Constants.APP_MINIMUM_WIDTH
    minimumHeight: Constants.APP_MINIMUM_HEIGHT

    property bool gameIsStarted: false

    menuBar: MenuBar
    {
        Menu
        {
            title: qsTr("&Game")

            MenuItem { action: newGameAction }
            MenuSeparator { }
            MenuItem { action: exitAction }
        }

        Menu
        {
            title: qsTr("&Help")
            MenuItem { action: aboutAction }
        }
    }

    ColumnLayout
    {
        anchors.fill : parent
        spacing: 2
        Board
        {
            id : chessBoard
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        TextInput
        {
            id : command
            height: 30
            Layout.fillWidth: true
            enabled: gameIsStarted

            onAccepted:
            {
                var engine = contextProvider.engine
                engine.sendCommand(text)
                text = ""
            }
        }
    }

    Action
    {
        id: newGameAction
        text: qsTr("&New Game")
        onTriggered:
        {
            gameIsStarted = contextProvider.engine.newGame()
            console.log("New game")
            chessBoard.update();
        }
    }

    Action
    {
        id: exitAction
        text: qsTr("E&xit")
        onTriggered: mainWindow.close()
    }

    Action
    {
        id: aboutAction
        text: qsTr("Abo&ut")
        onTriggered: console.log("Abo&ut")
    }

    MessageDialog
    {
        id: infoMessage
        icon: StandardIcon.Information
        title: qsTr("Info")
    }

    Connections
    {
       target : contextProvider.engine
       onMessage:
       {
           infoMessage.text = message
           infoMessage.open()
       }
    }

    MessageDialog
    {
        id: gameOverMessage
        title: qsTr("GameOver")
    }

    Connections
    {
       target : contextProvider.engine
       onGameOver:
       {
           gameOverMessage.text = message
           gameOverMessage.open()
           gameIsStarted = false;
       }
    }
}


