import QtQuick 2.0
import QtQuick.Controls 1.0
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

    Board
    {
        id : chessBoard
        anchors.fill : parent
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
}
