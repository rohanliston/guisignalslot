import QtQuick 2.0

NodeSocket {
    anchors.left: parent.right
    name: "Unnamed Output"
    color: "#3399FF"
    objectName: "output"

    Text {
        id: outputNameText
        anchors.right: parent.left
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        text: name
    }
}
