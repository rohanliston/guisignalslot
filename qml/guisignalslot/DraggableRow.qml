import QtQuick 2.0

Row {
    id: draggableRow
    anchors.fill: parent

    property Item tempDragItem: temp
    Item { id: temp; z: 10 }

    function dropObject(x, dropObject) {
        //Get the object under the drop position
        dropObject.parent = null
        var dropTarget = draggableRow.childAt(x, 0);
        var dropLeft = false;
        if (dropTarget === null) {
            dropTarget = draggableRow.children[draggableRow.children.length-1];
        } else {
            dropLeft = x<(dropTarget.x+dropTarget.width/2);
        }

        //Create a new ordering based on drop position
        var tempChildren = [];
        for (var i=0; i<draggableRow.children.length; i++) {
            if (draggableRow.children[i] === dropTarget) {
                if (dropLeft) {
                    tempChildren.push(dropObject);
                    tempChildren.push(draggableRow.children[i]);
                } else {
                    tempChildren.push(draggableRow.children[i]);
                    tempChildren.push(dropObject);
                }
            } else {
                tempChildren.push(draggableRow.children[i]);
            }
        }

        //reparent all items to the row to have them updated
        for (var j=0; j<tempChildren.length; j++) {
            tempChildren[j].parent = null;  //Break parenting relationship
            tempChildren[j].parent = draggableRow;  //Reparent
        }
    }
}
