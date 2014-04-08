import QtQuick 2.0
import QtQuick.Controls 1.1
import "FontAwesome.js" as FontAwesome

DraggableRowItem {
    property int position: Item.Left
    property string title: "Untitled Drawer"
    property int resizeDuration: 150
    property int gutterSize: 25
    property Item content

    onContentChanged: content.parent = rectContent

    id: root
    color: "LIGHTGRAY"
    height: parent.height
    clip: true
    Behavior on width { NumberAnimation { duration: root.resizeDuration } }

    state: "MAXIMISED"
    states: [
        State {
            name: "MINIMISED"
            PropertyChanges { target: root; width: root.gutterSize }
            PropertyChanges { target: btnSize; text: root.position === Item.Left ? FontAwesome.Icon.CaretRight : FontAwesome.Icon.CaretLeft }
            PropertyChanges { target: txtTitle; opacity: 0 }
            PropertyChanges { target: rectContent; opacity: 0 }
        },
        State {
            name: "MAXIMISED"
            when: root.hovering && !root.connecting
            PropertyChanges { target: btnSize; text: root.position === Item.Left ? FontAwesome.Icon.CaretLeft : FontAwesome.Icon.CaretRight }
        }
    ]

    Rectangle {
        id: rectTitleBar
        height: 30
        width: root.width
        color: "DARKGRAY"

        Button {
            id: btnSize
            anchors.verticalCenter: rectTitleBar.verticalCenter
            anchors.left:        root.position === Item.Left ? rectTitleBar.left : undefined
            anchors.leftMargin:  root.position === Item.Left ? 2 : 0
            anchors.right:       root.position === Item.Left ? undefined : rectTitleBar.right
            anchors.rightMargin: root.position === Item.Left ? 0 : 2

            width: 20
            height: 20
            onClicked: root.state = (root.state === "MINIMISED" ? "MAXIMISED" : "MINIMISED")
            text: root.position === Item.Left ? FontAwesome.Icon.CaretLeft : FontAwesome.Icon.CaretRight
        }

        Text {
            id: txtTitle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            x: 60
            text: root.title
            color: "WHITE"

            Behavior on opacity { NumberAnimation { duration: root.resizeDuration } }
        }
    }

    Rectangle {
        id: rectContent
        anchors.top: rectTitleBar.bottom
        anchors.bottom: root.bottom
        anchors.left: root.left
        anchors.right: root.right
        color: "LIGHTGRAY"

        Behavior on opacity { NumberAnimation { duration: root.resizeDuration } }
    }
}

