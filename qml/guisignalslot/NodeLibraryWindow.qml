import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {
    id: root

    color: "lightgray"
    height: parent.height
    Behavior on width { NumberAnimation { duration: 150 } }
    clip: true
    onWidthChanged: parent.update()

    state: "MAXIMISED"
    states: [
        State {
            name: "MINIMISED"
            PropertyChanges { target: root; width: 24 }
            PropertyChanges { target: sizeButton; text: "+" }
        },
        State {
            name: "MAXIMISED"
            when: root.hovering && !root.connecting
            PropertyChanges { target: root; width: parent.width * 0.2 }
            PropertyChanges { target: sizeButton; text: "-" }
        }
    ]


    Column {
        anchors.fill: parent

        Rectangle {
            id: titleBar
            height: 30
            width: parent.width
            color: "DARKGRAY"
            Button {
                id: sizeButton
                x: 2
                anchors.verticalCenter: parent.verticalCenter
                width: 20
                height: 20
                text: "-"
                onClicked: {
                    root.state = (root.state === "MINIMISED" ? "MAXIMISED" : "MINIMISED");
                }
            }

            Text {
                id: txtHeading
                anchors.verticalCenter: parent.verticalCenter
                x: 60
                text: "COMPONENT LIST"
                color: "WHITE"
            }
        }

        Rectangle {
            id: shim
            height: 2
            width: parent.width
            color: "LIGHTGRAY"
        }

        Column {
            height: parent.height - titleBar.height
            width: parent.width


            Button {
                id: btnAddNode
                width: parent.width - 24 - 1
                x: 25
                onClicked: editorWindow.addNode()

                Text {
                    x: 15
                    text: "Test Class"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
