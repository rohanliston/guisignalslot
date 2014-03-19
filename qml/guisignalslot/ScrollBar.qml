import QtQuick 2.0

Item {
    id: scrollBar
    // The properties that define the scrollbar's state.
    // position and pageSize are in the range 0.0 - 1.0.  They are relative to the
    // height of the page, i.e. a pageSize of 0.5 means that you can see 50%
    // of the height of the view.
    // orientation can be either 'Vertical' or 'Horizontal'
    property real position
    property real pageSize
    property string orientation : "Vertical"
    property alias bgColor: background.color
    property alias fgColor: slider.color
    property real setPosition

    property Flickable targetArea

    onOrientationChanged: console.log(orientation);
    // A light, semi-transparent background
    Rectangle {
        id: background
        radius: orientation == 'Vertical' ? (width/2 - 1) : (height/2 - 1)
        color: "lightgray"; opacity: 0.3
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent

            //Abandon all hope ye who enter here.
            onClicked: {
                if (scrollBar.orientation == 'Vertical') {
                    if (mouseY > (scrollBar.height-slider.height)) {
                        scrollBar.setPosition = 1.0
                    } else {
                         scrollBar.setPosition = (mouseY) / (scrollBar.height-slider.height);
                    }
                } else {
                    if (mouseX > (scrollBar.width-slider.width)) {
                        scrollBar.setPosition = 1.0
                    } else {
                        scrollBar.setPosition = (mouseX) / (scrollBar.width-slider.width);
                    }
                }
            }
        }
    }
    // Size the bar to the required size, depending upon the orientation.
    Rectangle {
        id: slider
        opacity: 0.7
        color: "black"
        radius: orientation == 'Vertical' ? (width/2 - 1) : (height/2 - 1)
        x: orientation == 'Vertical' ? 1 : (scrollBar.position * (scrollBar.width-2) + 1)
        y: orientation == 'Vertical' ? (scrollBar.position * (scrollBar.height-2) + 1) : 1
        width: orientation == 'Vertical' ? (parent.width-2) : (scrollBar.pageSize * (scrollBar.width-2))
        height: orientation == 'Vertical' ? (scrollBar.pageSize * (scrollBar.height-2)) : (parent.height-2)

        MouseArea {
            anchors.fill: parent
            anchors.margins: -10    // Increase mouse area a lot outside the slider.
            drag.target: parent;
            drag.axis: scrollBar.orientation ==  'Vertical' ? Drag.YAxis : Drag.XAxis
            drag.minimumX: 0;
            drag.maximumX: scrollBar.width - slider.width
            drag.minimumY: 0;
            drag.maximumY: scrollBar.height - slider.height

            onPositionChanged: {
                scrollBar.setPosition = scrollBar.orientation == 'Vertical' ? (slider.y / (scrollBar.height-slider.height)) : (slider.x / (scrollBar.width-slider.width));
            }
        }
    }
}
