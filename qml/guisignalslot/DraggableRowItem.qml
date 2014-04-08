import QtQuick 2.0

Rectangle {
    id: draggableRowItem
    property string name: "drag"
    width: draggableRow.width*0.25
    height: draggableRow.height
    border.width: 1
    border.color: "black"

    property color heldColor: "lightsteelblue"
    property color baseColor: "white"

    property bool isLeftSide: true

    color: dragArea.held ? heldColor : baseColor
    Behavior on color { ColorAnimation { duration: 100 } }

    Drag.active: dragArea.held
    Drag.source: dragArea
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.axis: Drag.XAxis
        drag.target: held ? draggableRowItem : undefined
        property bool held: false
        property DraggableRow dragRow


        onPressAndHold: {
            held = true;
            draggableRowItem.parent= draggableRowItem.parent.tempDragItem;
        }

        onReleased: {
            held = false;
            dragRow.dropObject(draggableRowItem.x+mouseX, draggableRowItem);
        }
    }

    Component.onCompleted: { dragArea.dragRow = parent }
}
