import QtQuick
import Quickshell
import qs.fuzzy

import ".."

Item {
	id: root

	property string searchString: ""

	property var availableActions: ([
		{name: "Wallpapers", comment:"Open Wallpaper Picker", nextState: Launcher.Mode.Wallpapers},
		{name: "Calculator", comment:"Enter an Expression to calculate", nextState: Launcher.Mode.Calculator},
		])

	property var filteredActions: {
		const cleanString = searchString.replace(">", "").trim()
		return Searcher.go(cleanString, availableActions, "name", 0.5)
	}

	readonly property int visibleItems: 7

	anchors.fill: parent

	implicitHeight: listView.height
	implicitWidth: listView.width

	function close() {
		searchString = ""
		listView.currentIndex = 0
		listView.positionViewAtBeginning()
	}

	function executeSelected(): int {
		const selected = filteredActions[listView.currentIndex]
		return selected.nextState
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
		AppItem {
			id: testItem
			visible: false
			modelData: ({
					name: "Sample name",
					comment: "Sample comment"
			})
		}

		width: testItem.implicitWidth
		height: Math.min(count, visibleItems) * (testItem.implicitHeight + spacing)

		clip: true

		highlight: null

		spacing: 12

		model: filteredActions

		reuseItems: true
		delegate: AppItem{}
	}
}
