import QtQuick
import qs.Common
import qs.Widgets

Row {
    property string text: ""
    property string iconName: ""
    property color borderColor: Theme.primary
    property color textColor: Theme.primary
    signal clicked()

    height: 36

    StyledRect {
        radius: Theme.cornerRadius
        color: "transparent"
        borderColor: parent.borderColor
        borderWidth: 1
        width: rowContent.width + Theme.spacingM * 2
        height: parent.height

        Row {
            id: rowContent
            anchors.centerIn: parent
            spacing: Theme.spacingS

            DankIcon {
                name: parent.parent.iconName
                size: 18
                color: parent.parent.textColor
                visible: parent.parent.iconName !== ""
            }

            StyledText {
                text: parent.parent.text
                color: parent.parent.textColor
                font.pixelSize: Theme.fontSizeSmall
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.parent.clicked()
        }
    }
}