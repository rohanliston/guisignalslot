import QtQuick 2.0

Rectangle {
    id: root
    width: 15
    height: 15
    color: {
        var result;

        if(isConnecting())
            result = connectingColor;
        else if(isConnected())
            result = connectedColor;
        else
            result = defaultColor;

        if(hovering)
            result = Qt.lighter(result);

        return result;
    }

    property string name: "Unnamed Socket"
    property string type: "socket"

    property variant connectedSockets: []

    property color defaultColor: "GRAY"
    property color connectingColor: "GRAY"
    property color connectedColor: "GREEN"
    property bool connecting: false
    property bool hovering: false

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

    function canConnectTo(otherSocket) {
        return (isInput() && otherSocket.isOutput()) || (isOutput() && otherSocket.isInput());
    }

    function addConnection(socket) {
        var connectionList = root.connectedSockets;
        connectionList.push(socket);
        root.connectedSockets = connectionList;
    }

    state: "NORMAL"
    states: [
        State {
            name: "NORMAL"
            when: root.connectedSockets.length === 0
        },
        State {
            name: "CONNECTED"
            when: root.connectedSockets.length > 0
        },
        State {
            name: "CONNECTING"
            when: root.connecting === true
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
