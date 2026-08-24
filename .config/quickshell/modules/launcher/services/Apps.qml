import QtQuick
import Quickshell
import qs.fuzzy
import ".."

Item {
	id: root

	property string searchString: ""

	property var filteredApps: Searcher.go(root.searchString, DesktopEntries.applications.values, "name", 0.5)

	readonly property int visibleItems: 7

	anchors.fill: parent

	implicitHeight: listView.height
	implicitWidth: listView.width

	function close() {
		searchString = ""
		listView.currentIndex = 0
		listView.positionViewAtBeginning()
	}

	function executeSelected(): Launcher.Mode {
		const selected = filteredApps[listView.currentIndex]
		if (selected.runInTerminal) {
			Quickshell.execDetached({
					command: ['tmux', 'new-window', '-n', `${selected.name}`, `"${selected.command.join(" ")}"`],
					workingDirectory: selected.workingDirectory
			})
		} else {
			selected.execute()
		}

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

		model: filteredApps

		reuseItems: true
		delegate: AppItem{}
	}
}
