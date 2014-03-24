import QtQuick 2.0

NodeSocket {
    id: root
    anchors.right: parent.left
    name: "Unnamed Input"
    objectName: "input"

    Text {
        id: txtInput
        anchors.left: parent.right
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        text: name
        color: root.color
    }
}
