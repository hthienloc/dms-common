import QtQuick
import qs.Common
import qs.Widgets

Rectangle {
    id: root

    property string iconName: ""
    property string label: ""
    property string shortcut: ""
    property color activeColor: Theme.primary

    signal clicked()

    radius: Theme.cornerRadius
    width: parent.width
    height: 52

    color: mouseArea.containsMouse ? Theme.withAlpha(activeColor, 0.12) : Theme.withAlpha(Theme.surfaceVariant, 0.08)
    border.color: mouseArea.containsMouse ? activeColor : "transparent"
    border.width: 1

    Row {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacingL
        anchors.rightMargin: Theme.spacingL
        spacing: Theme.spacingL

        DankIcon {
            name: root.iconName
            size: Theme.iconSize
            color: Theme.surfaceText
            anchors.verticalCenter: parent.verticalCenter
        }

        StyledText {
            text: root.label
            font.pixelSize: Theme.fontSizeMedium
            font.weight: Font.Medium
            color: Theme.surfaceText
            anchors.verticalCenter: parent.verticalCenter
        }

        Item { Layout.fillWidth: true }

        Rectangle {
            visible: root.shortcut !== ""
            width: shortcutLabel.implicitWidth + Theme.spacingM * 2
            height: shortcutLabel.implicitHeight + Theme.spacingS
            radius: Theme.cornerRadius / 2
            color: Theme.withAlpha(Theme.surfaceVariant, 0.5)
            anchors.verticalCenter: parent.verticalCenter

            StyledText {
                id: shortcutLabel
                text: root.shortcut
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceText
                opacity: 0.6
                anchors.centerIn: parent
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}