import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {
    id: root
    width: 1280
    height: 720

    Row {
        anchors.fill: parent

        NodeLibraryWindow {
            id: libraryWindow
            width: root.width * 0.2
        }

        Rectangle {
            width: parent.width-libraryWindow.width
            height: root.height
            Flickable {
                id: view
                width: parent.width
                height: parent.height
                contentHeight: editorWindow.height
                contentWidth: editorWindow.width
                clip: true

                NodeEditorWindow {
                    id: editorWindow
                }
            }

            // Attach scrollbars to the right and bottom edges of the view.
            ScrollBar {
                id: verticalScrollBar
                width: 12; height: parent.height-12
                anchors.right: parent.right
                opacity: 1
                orientation: 'Vertical'
                position: view.visibleArea.yPosition
                pageSize: view.visibleArea.heightRatio
                onSetPositionChanged: view.contentY=setPosition * (view.contentHeight-view.height);
            }

            ScrollBar {
                id: horizontalScrollBar
                width: parent.width-12; height: 12
                anchors.bottom: parent.bottom
                opacity: 1
                orientation: 'Horizontal'
                position: view.visibleArea.xPosition
                pageSize: view.visibleArea.widthRatio
                onSetPositionChanged: view.contentX=setPosition * (view.contentWidth-view.width);
            }
        }
    }
}
