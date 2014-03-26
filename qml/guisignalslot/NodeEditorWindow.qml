import QtQuick 2.0

Rectangle {
    id: root
    width: 1024
    height: 720

    property real scaleFactor: 1.0
    transform: Scale { origin.x: 0; origin.y: 0; xScale: root.scaleFactor; yScale: root.scaleFactor}

    property int mouseX
    property int mouseY

    property variant nodes: []
    property variant connections: []
    property Item pendingConnection
    property Item selectedNode

    property Canvas canvas: canvas

    function addNode() {
        // Create a new node.
        var node = Qt.createComponent("Node.qml");
        var instance = node.createObject(root);
        instance.onEntered.connect(root.nodeEntered);
        instance.onExited.connect(root.nodeExited);
        instance.onClicked.connect(root.nodeClicked);
        instance.onSocketEntered.connect(root.socketEntered);
        instance.onSocketExited.connect(root.socketExited);
        instance.onSocketClicked.connect(root.socketClicked);
        instance.onMouseMoved.connect(mouseArea.occludingMouseAreaUpdate);

        // Add it to the list.
        var nodeList = nodes;
        nodeList.push(instance);
        nodes = nodeList;
    }

    function nodeEntered(node) {
        canvas.requestPaint();
    }

    function nodeExited(node) {
        canvas.requestPaint();
    }

    function nodeClicked(node) {
        var selectedSameNode = (
                    root.selectedNode !== null &&
                    root.selectedNode === node &&
                    root.selectedNode.isSelected()
                    );

        if(root.selectedNode !== null) {
            root.selectedNode.deselect();
            root.selectedNode = null;
        }

        if(!selectedSameNode) {
            node.select();
            root.selectedNode = node;
        }

        canvas.requestPaint();
    }

    function socketEntered(socket) {
        if(pendingConnection !== null)
            pendingConnection.hoveringSocket = socket;

        canvas.requestPaint();
    }

    function socketExited(socket) {
        if(pendingConnection !== null)
            pendingConnection.hoveringSocket = null;

        canvas.requestPaint();
    }

    function socketClicked(socket) {
        if(root.pendingConnection === null)
            beginConnection(socket);
        else
            completeConnection(socket);

        canvas.requestPaint();
    }

    function beginConnection(sourceSocket) {
        var pendingConnectionComponent = Qt.createComponent("PendingConnection.qml");
        var newPendingConnection = pendingConnectionComponent.createObject(root);
        newPendingConnection.socket = sourceSocket;
        root.pendingConnection = newPendingConnection;
        sourceSocket.connecting = true;
    }

    function completeConnection(destSocket) {
        if(root.pendingConnection.canConnectTo(destSocket)) {
            var connectionComponent = Qt.createComponent("Connection.qml");
            var newConnection = connectionComponent.createObject(root);

            newConnection.inputSocket  = root.pendingConnection.socket.isInput() ? root.pendingConnection.socket : destSocket;
            newConnection.outputSocket = root.pendingConnection.socket.isOutput() ? root.pendingConnection.socket : destSocket;;

            var connectionList = root.connections;
            connectionList.push(newConnection);
            root.connections = connectionList;

            newConnection.inputSocket.addConnection(newConnection.outputSocket);
            newConnection.outputSocket.addConnection(newConnection.inputSocket);

            disconnectFromMouse();
        }
        else {
            console.log("Invalid connection!");
        }
    }

    function disconnectFromMouse() {
        if(root.pendingConnection)
        {
            root.pendingConnection.hoveringSocket = null;
            root.pendingConnection.socket.connecting = false;
            root.pendingConnection = null;
            canvas.requestPaint();
        }
    }

    signal nodePositionChanged
    onNodePositionChanged: {
        for (var i = 0, size = nodes.length; i < size; i++)
        {
            var node = nodes[i];

            var maxX = 0
            var maxY = 0

            if (node.x + node.width > maxX) {
                maxX = node.x + node.width;
            }
            if (node.y + node.height > maxY) {
                maxY = node.y + node.height;
            }
        }

        if (maxX > 1024) root.width = maxX;
        if (maxY > 720) root.height = maxY;
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        z: 1

        onPaint: {
            if(!context)
                getContext("2d");

            context.clearRect(0, 0, width, height);

            // If we're currently connecting something, draw it.
            if(root.pendingConnection !== null)
                root.pendingConnection.draw(context, root.mouseX, root.mouseY);

            // Draw all other connections.
            for(var i = 0; i < root.connections.length; ++i)
            {
                root.connections[i].draw(context);
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
                disconnectFromMouse();
                canvas.requestPaint();
            }
        }

        onWheel: {
            if (wheel.modifiers & Qt.ControlModifier) {
                if (wheel.angleDelta.y > 0)
                    root.scaleFactor *= 1.1;
                else
                    root.scaleFactor *= 0.9;
            }
        }

        onClicked: {
            if(root.selectedNode !== null) {
                root.selectedNode.deselect();
                root.selectedNode = null;
            }
        }
    }

    Text {
        id: txtMousePos
        color: "RED"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 10
        text: "(" + root.mouseX + "," + root.mouseY + ")";
    }
}
