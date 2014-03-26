import QtQuick 2.0
import QtQuick.Controls 1.1

Drawer {
    property Item node: editorWindow.selectedNode

    id: root
    position: Item.Right
    title: "Node Inspector"

    content: Column {
        id: colContent
        anchors.fill: parent
        spacing: 5
        anchors.margins: 10
        visible: node !== null

        Text { text: "Custom signals"; font.bold: true }
        Repeater {
            model: node !== null ? node.customSignalNames : 0
            CheckBox {
                text: node.customSignalNames[index]
            }
        }

        Item { width: colContent.width; height: 5 }
        Text { text: "Custom slots"; font.bold: true }
        Repeater {
            model: node !== null ? node.customSlotNames : 0
            CheckBox {
                text: node.customSlotNames[index]
            }
        }

        Item { width: colContent.width; height: 5 }
        Text { text: "Custom properties"; font.bold: true }
        Repeater {
            model: node !== null ? node.customPropertyNames : 0
            CheckBox {
                text: node.customPropertyNames[index]
            }
        }

        Item { width: colContent.width; height: 5 }
        Text { text: "Inherited properties"; font.bold: true }
        Repeater {
            model: node !== null ? node.inheritedPropertyNames : 0
            CheckBox {
                text: node.inheritedPropertyNames[index]
            }
        }
    }
}
