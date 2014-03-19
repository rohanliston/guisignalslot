import QtQuick 2.0

Rectangle {
    id: root
    width: 1280
    height: 720

    property int mouseX
    property int mouseY

    property variant nodes: []
    property variant connections: []
    property Item connectingSocket

    property Canvas canvas: canvas

    function addNode() {
        // Create a new node.
        var node = Qt.createComponent("Node.qml");
        var instance = node.createObject(editorWindow);
        instance.onSocketClicked.connect(editorWindow.socketClicked);
        instance.onMouseMovedOverNode.connect(editorWindow.mouseMovedOverNode);
        instance.onMouseMovedOverSocket.connect(editorWindow.mouseMovedOverSocket);

        // Add it to the list.
        var nodeList = nodes;
        nodeList.push(instance);
        nodes = nodeList;
    }

    function socketClicked(socket) {
        if(connectingSocket === null)
        {
            console.log("Starting connection from " + socket);
            connectingSocket = socket;
            connectingSocket.connecting = true;
        }
        else
        {
            var connectionList = root.connections;

            console.log("Connecting " + connectingSocket + " to " + socket);
            connectionList.push({"from": connectingSocket, "to": socket});
            connections = connectionList;
            cancelCurrentConnection();
        }
    }

    // @TODO: No longer necessary to have separate functions for this.
    function mouseMovedOverNode(node, x, y) {
        mouseArea.occludingMouseAreaUpdate(node, x, y);
    }
    function mouseMovedOverSocket(socket, x, y) {
        mouseArea.occludingMouseAreaUpdate(socket, x, y);
    }

    /*! Cancels the connection currently being made by the mouse. */
    function cancelCurrentConnection() {
        connectingSocket.connecting = false;
        connectingSocket = null;
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        z: 1

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
        /*!
            Triggered by MouseAreas that are in front of this one to let us know where the mouse is.
            This enables us to keep track of the mouse position over the entire editor window.
        */
        function occludingMouseAreaUpdate(occludingMouseArea, x, y) {
            var mappedPosition = root.mapFromItem(occludingMouseArea, x, y);

            // Let the canvas know where the mouse is
            root.mouseX = mappedPosition.x;
            root.mouseY = mappedPosition.y;
            canvas.requestPaint();
        }

        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPositionChanged: {
            root.mouseX = mouseX;
            root.mouseY = mouseY;
            canvas.requestPaint();
        }
        onPressed: {
            if(pressedButtons & Qt.RightButton)
            {
                cancelCurrentConnection();
                canvas.requestPaint();
            }
        }
    }

    Text {
        id: txtMousePos
        color: "RED"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        text: "(" + root.mouseX + "," + root.mouseY + ")";
    }
}
