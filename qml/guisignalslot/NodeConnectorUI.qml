import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {
    id: root
    width: 1280
    height: 720

    NodeLibraryWindow {
        id: libraryWindow
        width: parent.width * 0.2
        height: parent.height
    }

    NodeEditorWindow {
        id: editorWindow
        width: parent.width - libraryWindow.width
        height: parent.height
        anchors.left: libraryWindow.right
    }
}
