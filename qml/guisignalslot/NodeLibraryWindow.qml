import QtQuick 2.0
import QtQuick.Controls 1.1

Drawer {
    id: root
    title: "Node Library"
    position: Item.Left

    content: Column {
        anchors.fill: parent
        anchors.margins: 10

        Button {
            id: btnAddNode
            width: parent.width
            onClicked: editorWindow.addNode()

            Text {
                x: 15
                text: "Test Class"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}


