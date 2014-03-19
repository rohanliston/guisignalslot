import QtQuick 2.0
import ComponentConnector 1.0
import TestClass 1.0

Rectangle {
    id: root
    width: 360
    height: 360
    x: 360
    color: "TRANSPARENT"
    clip: false

    property variant inputs: []
    property variant outputs: []
    readonly property variant sockets: inputs.concat(outputs)
    property variant connections: []

    property Item ui

    signal socketClicked(Item socket)
    signal mouseMovedOverNode(Item node, int x, int y)
    signal mouseMovedOverSocket(Item socket, int x, int y)

    ComponentConnector {
        id: connector
        componentName: "TestClass"
        targetObject: TestClass {}
        anchors.fill: parent

        Rectangle {
            property int socketOffset: 50

            id: nodeBox
            anchors.fill: parent
            anchors.margins: 30
            border.color: "BLACK"
            radius: 10

            // Node heading.
            Text {
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: connector.componentName
                font.bold: true
            }

            // Inputs (slots).
            Repeater {
                model: connector.customSlotNames

                NodeInput {
                    id: inputSocket
                    name: connector.customSlotNames[index]
                    y: nodeBox.socketOffset + (index * 30)
                    parent: nodeBox
                    onClicked: socketClicked(this)
                    onMousePositionChanged: root.mouseMovedOverSocket(this, x, y)

                    Component.onCompleted: {
                        var socketList = inputs;
                        socketList.push(this);
                        inputs = socketList;
                    }
                }
            }

            // Outputs (signals).
            Repeater {
                model: connector.customSignalNames

                NodeOutput {
                    id: outputSocket
                    name: connector.customSignalNames[index]
                    y: nodeBox.socketOffset + (index * 30)
                    parent: nodeBox
                    onClicked: socketClicked(this)
                    onMousePositionChanged: root.mouseMovedOverSocket(this, x, y)

                    Component.onCompleted: {
                        var socketList = outputs;
                        socketList.push(this);
                        outputs = socketList;
                    }
                }
            }

            // Makes the node draggable.
            MouseArea {
                anchors.fill: parent
                drag.target: root
                drag.axis: Drag.XAndYAxis
                drag.minimumX: 0
                drag.maximumX: root.parent.width - root.width
                drag.minimumY: 0
                drag.maximumY: root.parent.height - root.height
                propagateComposedEvents: true
                onPositionChanged: root.mouseMovedOverNode(this, mouseX, mouseY)
            }
        }
    }
}
