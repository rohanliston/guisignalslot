import QtQuick 2.0

Item {
    id: root

    property Item inputSocket
    property Item outputSocket

    property real curveScale: 0.5
    property color color: inputSocket !== null ? inputSocket.connectedColor : "GREEN"

    signal mouseHover

    function draw(context) {
        var outputPos = mapFromItem(root.outputSocket, root.outputSocket.width / 2, root.outputSocket.height / 2);
        var inputPos  = mapFromItem(root.inputSocket,  root.inputSocket.width / 2,  root.inputSocket.height / 2);

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
