import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets

import qs.components.colors
import qs.components.states

Item {
	id: root

	required property var modelData

	readonly property bool isCurrent: ListView.isCurrentItem
	readonly property ScreenState screenState: ShellState.forMainScreen()

	readonly property real shadowMarginY: Math.abs(shadow.offset.y)
	readonly property real shadowMarginX: Math.abs(shadow.offset.x)

	implicitHeight: item.implicitHeight + (shadowMarginY * 2)
	implicitWidth: (screenState.modelData.width * 0.2) + (shadowMarginX * 2)

	width: implicitWidth

	RectangularShadow {
		id: shadow
		anchors.fill: background
		z: -1

		offset.x: 3
		offset.y: 3

		radius: background.radius
		blur: 8
		spread: 0
		color: Qt.rgba(0, 0, 0, 0.25)
	}

	Rectangle {
		id: background

		radius: 20

		anchors.fill: parent

		anchors.leftMargin: root.shadowMarginX
		anchors.rightMargin: root.shadowMarginX

		anchors.topMargin: 0
		anchors.bottomMargin: root.shadowMarginY

		anchors.centerIn: parent

		color: isCurrent ? Colors.accent : Colors.surface

		Item {
			id: item
			anchors.fill: parent
			anchors.margins: 12

			implicitHeight: name.implicitHeight + comment.implicitHeight + (anchors.margins * 2)

			IconImage {
				id: icon
				asynchronous: true
				source: Quickshell.iconPath(modelData?.icon?.split("?")[0], "icon-missing")
				implicitSize: parent.height * 0.8
				anchors.verticalCenter: parent.verticalCenter
			}

			Item {
				anchors.left: icon.right
				anchors.leftMargin: 8
				anchors.verticalCenter: icon.verticalCenter
				implicitHeight: name.implicitHeight + comment.implicitHeight
				implicitWidth: parent.width - icon.width

				Text {
					id: name
					text: modelData?.name ?? "No Name"
					font.pointSize: 12
					color: isCurrent ? Colors.bg : Colors.fg
				}

				Text {
					id: comment
					text: (modelData?.comment || modelData?.genericName || modelData?.name) ?? ""
					color: isCurrent ? Colors.bg : Colors.fg

					elide: Text.ElideRight
					width: item.width - icon.width - 4
					anchors.top: name.bottom
				}
			}
		}

	}
}
