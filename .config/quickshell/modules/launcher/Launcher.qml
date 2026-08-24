import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.components
import qs.components.states
import qs.components.colors
import "services"

PanelWindow {
	id: root

	enum Mode { Closed, Apps, Actions, Wallpapers }

	property int activeMode: Launcher.Mode.Apps

	property ScreenState screenState: ShellState.forMainScreen()

	visible: screenState.launcher

	implicitWidth:  screenState.modelData.width
	implicitHeight: screenState.modelData.height

	WlrLayershell.layer: WlrLayer.Overlay

	color: "transparent"

	mask: Region {item: wrapper}

	function close() {
		input.clear()
		loader.item.close()
		activeMode = Launcher.Mode.Apps
		screenState.launcher = false
	}

	function selectCurrent() {
		const nextState = loader.item.executeSelected()
		if (nextState == Launcher.Mode.Closed) {
			root.close()
		} else {
			activeMode = nextState
			input.clear()
		}
	}

	HyprlandFocusGrab {
		active: root.visible
		id: focusGrabber
		windows: [root]

		onCleared: root.close()
	}

	Rectangle {
		id: wrapper

		readonly property real inset: 16

		anchors.centerIn: parent

		width: selectorWrapper.width + inset*2
		height: selectorWrapper.height + inputBg.height + inset*4

		color: Colors.bg
		radius: 20

		border.color: Colors.accent
		border.width: 1

		//////////
		// KEYS //
		//////////

		Keys.onEscapePressed: (event) => {
			root.close()
			event.accepted = true
		}

		Keys.onEnterPressed: (event) => {
			root.selectCurrent()
			event.accepted = true
		}

		Keys.onReturnPressed: (event) => {
			root.selectCurrent()
			event.accepted = true
		}

		Keys.onLeftPressed: (event) => {
			loader.item.previous()
			event.accepted = true
		}

		Keys.onUpPressed: (event) => {
			loader.item.previous()
			event.accepted = true
		}

		Keys.onRightPressed: (event) => {
			loader.item.next()
			event.accepted = true
		}

		Keys.onDownPressed: (event) => {
			loader.item.next()
			event.accepted = true
		}

		Keys.onPressed: (event) => {
			// handle Ctrl_n and Ctrl_p for up and down
			if (!(event.modifiers & Qt.ControlModifier)) return // didn't click ctrl

			if (event.key == Qt.Key_N) {
				loader.item.next()
				event.accepted = true
				return
			}

			if (event.key == Qt.Key_P) {
				loader.item.previous()
				event.accepted = true
				return
			}

			if (event.key == Qt.Key_Y) {
				root.selectCurrent()
				event.accepted = true
				return
			}
		}

		Item {
			id: selectorWrapper

			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right

			anchors.margins: wrapper.inset

			height: loader.item.implicitHeight
			width: loader.item.implicitWidth

			Loader {
				id: loader

				readonly property Component apps: Apps{}
				readonly property Component actions: Actions{}
				readonly property Component wallpapers: Wallpapers{}

				anchors.top: parent.top
				anchors.left: parent.left
				anchors.right: parent.right

				height: item.implicitHeight
				width: item.implicitWidth

				sourceComponent: {
					if (root.activeMode === Launcher.Mode.Apps) return apps;
					if (root.activeMode === Launcher.Mode.Actions) return actions
					if (root.activeMode === Launcher.Mode.Wallpapers) return wallpapers
				}
			}
		}

		Rectangle {
			id: inputBg
			color: Colors.surface

			border.width: 1
			border.color: Colors.accent

			radius: 12

			anchors.bottom: parent.bottom
			anchors.left: parent.left
			anchors.right: parent.right

			anchors.margins: wrapper.inset

			height: 40

			TextInput {
				id: input

				anchors.fill: parent
				anchors.margins: 8
				focus: true
				font.pointSize: 12
				color: Colors.fg

				onTextEdited: () => {
					if (input.length === 1 && input.text[0] === ">") {
						root.activeMode = Launcher.Mode.Actions
					} else if (input.text === "" && root.activeMode == Launcher.Mode.Actions) {
						root.activeMode = Launcher.Mode.Apps
					}
				}
			}
		}

		Binding {
			target: loader.item
			property: "searchString"
			value: input.text
		}
	}
}
