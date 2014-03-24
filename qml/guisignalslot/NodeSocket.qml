import QtQuick 2.0

Rectangle {
    id: root
    width: 15
    height: 15
    color: {
        var result;

        if(hasInvalidConnectionHovering())
            result = invalidConnectionColor;
        else if(hasPotentialConnectionHovering())
            result = potentialConnectionColor;
        else if(isConnecting())
            result = connectingColor;
        else if(isConnected())
            result = connectedColor;
        else
            result = defaultColor;

        if(hovering || highlighted)
            result = Qt.lighter(result);

        return result;
    }

    property string name: "Unnamed Socket"
    property string type: "socket"

    property variant connectedSockets: []

    property color defaultColor: "GRAY"
    property color connectingColor: "BLACK"
    property color potentialConnectionColor: "GREEN"
    property color invalidConnectionColor: "RED"
    property color connectedColor: "GREEN"
    property bool connecting: false
    property bool potentialConnectionHovering: false
    property bool invalidConnectionHovering: false
    property bool hovering: false
    property bool highlighted: false

    signal clicked
    signal entered
    signal exited
    signal mouseMoved(int x, int y)

    function isInput() {
        return root.objectName === "input";
    }

    function isOutput() {
        return root.objectName === "output";
    }

    function isConnecting() {
        return state === "CONNECTING";
    }

    function isConnected() {
        return state === "CONNECTED";
    }

    function hasPotentialConnectionHovering() {
        return state === "POTENTIAL_CONNECTION_HOVERING";
    }

    function hasInvalidConnectionHovering() {
        return state === "INVALID_POTENTIAL_CONNECTION_HOVERING";
    }

    function canConnectTo(otherSocket) {
        return (isInput() && otherSocket.isOutput()) || (isOutput() && otherSocket.isInput());
    }

    function addConnection(socket) {
        var connectionList = root.connectedSockets;
        connectionList.push(socket);
        root.connectedSockets = connectionList;
        highlightConnections(hovering);
    }

    function highlightConnections(highlight) {
        for(var i = 0; i < connectedSockets.length; i++) {
            connectedSockets[i].highlighted = highlight;
        }
    }

    onHoveringChanged: highlightConnections(hovering)

    state: "NORMAL"
    states: [
        State {
            name: "INVALID_POTENTIAL_CONNECTION_HOVERING"
            when: root.invalidConnectionHovering === true
        },
        State {
            name: "POTENTIAL_CONNECTION_HOVERING"
            when: root.potentialConnectionHovering === true
        },
        State {
            name: "CONNECTING"
            when: root.connecting === true
        },
        State {
            name: "NORMAL"
            when: root.connectedSockets.length === 0
        },
        State {
            name: "CONNECTED"
            when: root.connectedSockets.length > 0
        }
    ]

    MouseArea {
        id: mouseArea
        anchors.fill: root
        hoverEnabled: true
        propagateComposedEvents: true
        onEntered: {
            root.hovering = true;
            root.entered();
        }
        onExited: {
            root.hovering = false;
            root.exited();
        }
        onClicked: root.clicked();
        onPositionChanged: root.mouseMoved(mouseX, mouseY)
    }
}
