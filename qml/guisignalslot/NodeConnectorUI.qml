import QtQuick 2.0
import QtQuick.Controls 1.1
import "FontAwesome.js" as FontAwesome

Rectangle {
    id: root
    width: 1280
    height: 720
    color: "darkgray"

    FontLoader {
        source: "resources/fontawesome-webfont.ttf"
    }

    DraggableRow {
        id: row
        anchors.fill: root

        NodeLibraryWindow {
            id: libraryWindow
            name: "libraryWindow"
            width: 200
            height: row.height
        }

        Rectangle {
            id: editorWindowComponents
            width: row.width - libraryWindow.width - inspectorWindow.width
            height: row.height

            Flickable {
                id: view
                width: parent.width
                height: parent.height
                contentHeight: editorWindow.height * editorWindow.scaleFactor
                contentWidth: editorWindow.width * editorWindow.scaleFactor
                clip: true

                NodeEditorWindow {
                    id: editorWindow
                    height: editorWindowComponents.height
                    width: editorWindowComponents.width
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
                onSetPositionChanged: view.contentY = setPosition * (view.contentHeight - view.height);
            }

            ScrollBar {
                id: horizontalScrollBar
                width: parent.width-12; height: 12
                anchors.bottom: parent.bottom
                opacity: 1
                orientation: 'Horizontal'
                position: view.visibleArea.xPosition
                pageSize: view.visibleArea.widthRatio
                onSetPositionChanged: view.contentX = setPosition * (view.contentWidth - view.width);
            }

            Button {
                id: zoomIn
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 15
                anchors.topMargin: 5
                width: 25
                height: 25
                onClicked: editorWindow.scaleFactor *= 1.25
                text: FontAwesome.Icon.ZoomIn
            }

            Button {
                id: zoomOut
                anchors.right: zoomIn.left
                anchors.top: parent.top
                anchors.topMargin: 5
                width: 25
                height: 25
                onClicked: editorWindow.scaleFactor *= 0.8
                text: FontAwesome.Icon.ZoomOut
            }
        }

        NodeInspectorWindow {
            id: inspectorWindow
            name: "inspectorWindow"
            width: 200
            height: row.height
        }
    }
}
