import QtQuick 2.0

Rectangle {
    id: root
    width: 15
    height: 15
    color: "GRAY"

    property string name: "Unnamed Socket"
    property string type: "socket"

    property bool hovering: false
    property bool connecting: false

    property color initialColour
    Component.onCompleted: initialColour = color;

    signal clicked
    signal entered
    signal exited
    signal mouseMoved(int x, int y)

    state: "NORMAL"
    states: [
        State {
            name: "NORMAL"
            when: !root.hovering && !root.connecting
        },
        State {
            name: "HOVERING"
            when: root.hovering && !root.connecting
            PropertyChanges { target: root; color: Qt.darker(root.initialColour) }
        },
        State {
            name: "CONNECTING"
            when: root.connecting
            PropertyChanges { target: root; color: "BLACK" }
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
