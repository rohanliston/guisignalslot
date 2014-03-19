import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {
    id: root
    width: 1280
    height: 720

    property variant nodes: []
    property variant connections: []
    property Item connectingSocket

    property Canvas canvas: connectionCanvas

    function socketClicked(socket) {
        if(connectingSocket === null)
        {
            console.log("Starting connection from " + socket);
            connectingSocket = socket;
        }
        else
        {
            var connectionList = root.connections;

            console.log("Connecting " + connectingSocket + " to " + socket);
            connectionList.push({"from": connectingSocket, "to": socket});
            connections = connectionList;
            connectingSocket = null;
        }
    }

    function mouseMovedOverNode(node, x, y) {
        mousePositionChanged(node, x, y);
    }

    // @TODO: Remove copy-pasted code
    function mouseMovedOverSocket(socket, x, y) {
        var mappedPosition = rightCol.mapFromItem(socket, x, y);
        mousePositionChanged(socket, socket.width/2, socket.height/2);
        mousePos.text = "(" + mappedPosition.x + "," + mappedPosition.y + ")";
        connectionCanvas.requestPaint();
    }

    function mousePositionChanged(item, x, y) {
        var mappedPosition = rightCol.mapFromItem(item, x, y);
        connectionCanvas.mouseX = mappedPosition.x;
        connectionCanvas.mouseY = mappedPosition.y;
        mousePos.text = "(" + mappedPosition.x + "," + mappedPosition.y + ")";
        connectionCanvas.requestPaint();
    }

    Rectangle {
        id: leftCol
        width: parent.width * 0.2
        height: parent.height
        color: "GRAY"

        Text {
            id: leftColHeading
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            text: "Component list"
            anchors.top: parent.top
            anchors.topMargin: 10
        }

        Column {
            anchors.fill: parent
            anchors.margins: 40

            Button {
                id: btnAddConnector
                width: parent.width
                text: "TestClass"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    // Create a new node.
                    var node = Qt.createComponent("Node.qml");
                    var instance = node.createObject(rightCol);
                    instance.onSocketClicked.connect(root.socketClicked);
                    instance.onMouseMovedOverNode.connect(root.mouseMovedOverNode);
                    instance.onMouseMovedOverSocket.connect(root.mouseMovedOverSocket);

                    // Add it to the list.
                    var nodeList = nodes;
                    nodeList.push(instance);
                    nodes = nodeList;
                }
            }
        }
    }

    Rectangle {
        id: rightCol
        width: parent.width - leftCol.width
        height: parent.height
        anchors.left: leftCol.right

        Canvas {
            id: connectionCanvas
            anchors.fill: parent
            z: 1

            property int mouseX
            property int mouseY

            function drawConnection(x1, y1, x2, y2, direction, scale) {
                var ctrlPtDist = Math.abs(x2 - x1) * scale * direction;

                var ctrlPt1X = x1 + ctrlPtDist;
                var ctrlPt1Y = y1;
                var ctrlPt2X = x2 - ctrlPtDist;
                var ctrlPt2Y = y2;

                context.beginPath();
                context.moveTo(x1, y1);
                context.bezierCurveTo(ctrlPt1X, ctrlPt1Y, ctrlPt2X, ctrlPt2Y, x2, y2);
                context.stroke();
            }

            onPaint: {
                if(!context)
                    getContext("2d");

                context.clearRect(0, 0, width, height);

                // If we're currently connecting something, draw it.
                if(root.connectingSocket !== null)
                {
                    var direction = root.connectingSocket.objectName === "input" ? -1 : 1;
                    var socketPos = mapFromItem(root.connectingSocket, root.connectingSocket.width/2, root.connectingSocket.height/2);

                    drawConnection(socketPos.x, socketPos.y, mouseX, mouseY, direction, 0.5);
                }

                // Draw all other connections.
                for(var i = 0; i < root.connections.length; ++i)
                {
                    direction = root.connections[i]["from"].objectName === "input" ? -1 : 1;
                    var source = root.connections[i]["from"];
                    var dest = root.connections[i]["to"];

                    var sourcePos = mapFromItem(source, source.width/2, source.height/2);
                    var destPos = mapFromItem(dest, dest.width/2, dest.height/2);

                    drawConnection(sourcePos.x, sourcePos.y, destPos.x, destPos.y, direction, 0.5);
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onPositionChanged: {
                mousePos.text = "(" + mouseX + "," + mouseY + ")";
                connectionCanvas.mouseX = mouseX;
                connectionCanvas.mouseY = mouseY;
                connectionCanvas.requestPaint();
            }
            onPressed: {
                if(pressedButtons & Qt.RightButton)
                {
                    root.connectingSocket = null;
                    connectionCanvas.requestPaint();
                }
            }
        }

        Text {
            id: mousePos
            color: "RED"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 10
            text: "(0,0)"
        }
    }
}
