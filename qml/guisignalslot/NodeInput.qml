import QtQuick 2.0

NodeSocket {
    anchors.right: parent.left
    name: "Unnamed Input"
    color: "#FF9933"
    objectName: "input"

    Text {
        id: inputNameText
        anchors.left: parent.right
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        text: name
    }
}
