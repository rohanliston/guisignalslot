import QtQuick 2.0

Item {
    id: root

    property Item inputSocket
    property Item outputSocket

    property real curveScale: 0.5
    property color color: "BLACK"
    property bool isPending: false

    property real mouseX
    property real mouseY

    signal mouseHover

    function canConnect(otherSocket) {
        return (otherSocket.isOutput() && root.outputSocket === null) || (otherSocket.isInput() && root.inputSocket === null);
    }

    function hasInput() {
        return root.inputSocket !== null;
    }

    function hasOutput() {
        return root.outputSocket !== null;
    }

    function draw(context) {
        var outputPos = root.hasOutput() ? mapFromItem(root.outputSocket, root.outputSocket.width / 2, root.outputSocket.height / 2) : Qt.point(root.mouseX, root.mouseY);
        var inputPos  = root.hasInput()  ? mapFromItem(root.inputSocket,  root.inputSocket.width / 2,  root.inputSocket.height / 2)  : Qt.point(root.mouseX, root.mouseY);

        // Calculate control points.
        var ctrlPtDist = Math.abs(inputPos.x - outputPos.x) * root.curveScale;
        var ctrlPt1X = outputPos.x + ctrlPtDist;
        var ctrlPt1Y = outputPos.y;
        var ctrlPt2X = inputPos.x - ctrlPtDist;
        var ctrlPt2Y = inputPos.y;

        // Draw bezier curve.
        context.beginPath();
        context.strokeStyle = root.color;
        context.moveTo(outputPos.x, outputPos.y);
        context.bezierCurveTo(ctrlPt1X, ctrlPt1Y, ctrlPt2X, ctrlPt2Y, inputPos.x, inputPos.y);
        context.stroke();
    }
}
