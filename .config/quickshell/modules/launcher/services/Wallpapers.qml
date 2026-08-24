import QtQuick
import Quickshell
import qs.fuzzy

import ".."

Item {
	id: root

	property string searchString: ""

	property var availableWallpapers: ([
		{name: "Current", path: "~Pictures/wallpapers/current" },
		])

	readonly property int visibleItems: 7

	anchors.fill: parent

	implicitHeight: listView.height
	implicitWidth: listView.width

	function close() {
		searchString = ""
		listView.currentIndex = 0
		listView.positionViewAtBeginning()
	}

	function executeSelected(): bool {
		const selected = filteredActions[listView.currentIndex]
		// Set wallpaper

		return Launcher.Mode.Closed
	}

	function next(): void {
		listView.incrementCurrentIndex()
		listView.positionViewAtIndex(listView.currentIndex, ListView.Center)
	}

	function previous(): void {
		listView.decrementCurrentIndex()
		listView.positionViewAtIndex(listView.currentIndex, ListView.Center)
	}

	ListView {
		id: listView

		// Test instance for layouting
		WallpaperItem {
			id: testItem
			visible: false
			modelData: ({
					name: "Sample name",
					path: "~/Pictures/wallpapers/current"
			})
		}

		width: testItem.implicitWidth
		height: Math.min(count, visibleItems) * (testItem.implicitHeight + spacing)

		clip: true

		highlight: null

		spacing: 12

		model: availableWallpapers

		reuseItems: true
		delegate: WallpaperItem{}
	}
}
