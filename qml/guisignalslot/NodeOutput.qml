import QtQuick 2.0

NodeSocket {
    id: root
    anchors.left: parent.right
    name: "Unnamed Output"
    objectName: "output"

    Text {
        id: txtOutputName
        anchors.right: parent.left
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        text: name
        color: root.color
    }
}
