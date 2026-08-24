pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root
	FileView {
		id: colorsFile
		path: Quickshell.env("HOME") + "/.cache/iris/colors.json"
		blockLoading: true
	}

	readonly property var palette: JSON.parse(colorsFile.text())

	readonly property color bg: palette.bg
	readonly property color fg: palette.fg
	readonly property color surface: palette.surface
	readonly property color dim: palette.dim
	readonly property color accent: palette.accent
	readonly property color red: palette.red
	readonly property color green: palette.green
	readonly property color yellow: palette.yellow

	// Syntactic
	readonly property color syntax_keyword: palette.syntax_keyword
	readonly property color syntax_string: palette.syntax_string
	readonly property color syntax_func: palette.syntax_func
	readonly property color syntax_type: palette.syntax_type
	readonly property color syntax_const: palette.syntax_const
	readonly property color syntax_comment: palette.syntax_comment
	readonly property color syntax_param: palette.syntax_param
	readonly property color syntax_operator: palette.syntax_operator
}
