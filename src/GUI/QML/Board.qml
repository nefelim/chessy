import QtQuick 2.0
import "Constants.js" as Constants

Rectangle
{
    id: boardRectangle
    width: Constants.BOARD_MINIMUM_WIDTH
    height: Constants.BOARD_MINIMUM_HEIGHT
    property alias board: squares
    Repeater
    {
        id: squares
        model: Constants.BOARD_SIZE * Constants.BOARD_SIZE
        Rectangle
        {
            id : cell
            x : (index % Constants.BOARD_SIZE) * boardRectangle.width / Constants.BOARD_SIZE
            y : Math.floor(index / Constants.BOARD_SIZE) * boardRectangle.height / Constants.BOARD_SIZE
            border.width: 1
            width: boardRectangle.width / Constants.BOARD_SIZE
            height: boardRectangle.height / Constants.BOARD_SIZE
            state :  "free"
            states:
            [
                State
                {
                    name: "picked";
                    PropertyChanges { target: cell; color: Constants.CELL_HILIGHT_COLOR}
                },
                State
                {
                    name: "free";
                    PropertyChanges
                    {
                        target: cell;
                        color:
                        {
                            var index = cell.x / cell.width + Constants.BOARD_SIZE * cell.y / cell.height
                            if (Math.floor(index / Constants.BOARD_SIZE + 1) % 2 == 0 )
                                color = ((index + 1) % 2 == 0) ? Constants.CELL_LIGHT_COLOR : Constants.CELL_DARK_COLOR
                            else
                                color = ((index + 1) % 2 == 0) ? Constants.CELL_DARK_COLOR : Constants.CELL_LIGHT_COLOR
                        }
                    }
                }
            ]
            Image
            {
                id : pieceImage
                anchors.fill : parent
                fillMode : Image.Stretch
                source :
                {
                    var engine = contextProvider.engine
                    var board = engine.boardState
                    if (board === "")
                    {
                        return "";
                    }

                    var path = "../images/pieces/"
                    var pieceChar = board[index]
                    if (pieceChar === '.')
                    {
                        return "";
                    }

                    path += (pieceChar > 'a' && pieceChar < 'z') ? 'b' : 'w'
                    path += pieceChar.toLowerCase()
                    return path
                }
            }
        }
    }

    Connections
    {
       target : contextProvider.engine
       onBoardChanged:
       {
           console.log("boardChanged")
           board.update();
       }
    }
}
