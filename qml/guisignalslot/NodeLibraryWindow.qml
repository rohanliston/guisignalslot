import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {
    color: "GRAY"

    Text {
        id: txtHeading
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        text: "Component list"
        anchors.top: parent.top
        anchors.topMargin: 10
    }

    Column {
        anchors.fill: parent
        anchors.margins: 40

        Button {
            id: btnAddNode
            width: parent.width
            text: "TestClass"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: editorWindow.addNode()
        }
    }
}
