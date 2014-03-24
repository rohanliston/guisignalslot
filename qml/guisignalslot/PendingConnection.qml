import QtQuick 2.0

Item {
    id: root

    property Item socket

    property real curveScale: 0.5
    property color color: socket !== null ? socket.connectingColor : "GRAY"

    function canConnectTo(otherSocket) {
        return root.socket.canConnectTo(otherSocket);
    }

    function draw(context, mouseX, mouseY) {
        var socketPos = mapFromItem(root.socket, root.socket.width / 2, root.socket.height / 2);
        var direction = socket.isInput() ? -1 : 1;

        // Calculate control points.
        var ctrlPtDist = Math.abs(mouseX - socketPos.x) * direction * root.curveScale;
        var ctrlPt1X = socketPos.x + ctrlPtDist;
        var ctrlPt1Y = socketPos.y;
        var ctrlPt2X = mouseX - ctrlPtDist;
        var ctrlPt2Y = mouseY;

        // Draw bezier curve.
        context.beginPath();
        context.strokeStyle = root.color;
        context.moveTo(socketPos.x, socketPos.y);
        context.bezierCurveTo(ctrlPt1X, ctrlPt1Y, ctrlPt2X, ctrlPt2Y, mouseX, mouseY);
        context.stroke();
    }
}
