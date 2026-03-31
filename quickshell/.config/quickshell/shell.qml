//@ pragma UseQApplication
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

PanelWindow {
	id: root
	anchors.top: true
	anchors.left: true
	anchors.right: true
	implicitHeight: 35
	color: bg

	property int cpuUsage: 0
	property int memUsage: 0

	property var lastCpuIdle: 0
	property var lastCpuTotal: 0
	property var lastRxBytes: 0
	property var lastTxBytes: 0


	property string rxSpeed: "0 KB/s"
	property string txSpeed: "0 KB/s"

	readonly property string bg: "#1d2021"  
	readonly property string fg: "#ebdbb2"
	readonly property string yellow: "#d79921" 
	readonly property string aqua: "#83a598" 
	readonly property string green: "#b8bb26"
	readonly property string orange: "#fe8019" 
	readonly property string purple: "#d3869b" 
	readonly property string bg3: "#504945" 

	property var workspaces: []

	property string clockTime: ""
	property string clockDate: ""

	Timer {
		interval: 1000
		running: true
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			const now = new Date()
			const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
			const day = days[now.getDay()]
			const h = String(now.getHours()).padStart(2, "0")
			const m = String(now.getMinutes()).padStart(2, "0")
			const s = String(now.getSeconds()).padStart(2, "0")
			const date = now.getDate() + "/" + String(now.getMonth() + 1).padStart(2, "0") + "/" + now.getFullYear()
			clockTime = day + "  " + h + ":" + m 
			clockDate = date
		}
	}

	Process {
		id: fetchWorkspaces
		command: ["niri", "msg", "-j", "workspaces"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				try {
					const parsed = JSON.parse(data)
					if (Array.isArray(parsed)) workspaces = parsed.slice().sort((a, b) => a.idx - b.idx)
				} catch(e) {}
			}
		}
	}

	Process {
		id: netProc
		command: ["sh", "-c", "awk 'NR>2{rx+=$2; tx+=$10} END{print rx, tx}' /proc/net/dev"]
		stdout: SplitParser {
			onRead: data => {
				const parts = data.trim().split(/\s+/)
				const rx = parseInt(parts[0])
				const tx = parseInt(parts[1])
				if (lastRxBytes > 0) {
					rxSpeed = formatSpeed(rx - lastRxBytes)
					txSpeed = formatSpeed(tx - lastTxBytes)
				}
				lastRxBytes = rx
				lastTxBytes = tx
			}
		}
	}

	Process {
		id: eventStream
		command: ["niri", "msg", "event-stream"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				if (data.startsWith("Workspace")) {
					fetchWorkspaces.running = false
					fetchWorkspaces.running = true
				}
			}
		}
	}

	function formatSpeed(bytes) {
		const perSec = bytes / 2  
		if (perSec >= 1048576) return (perSec / 1048576).toFixed(1) + " MB/s" // ts is just 1024**2

		return Math.round(perSec / 1024) + " KB/s"
	}

	RowLayout {
		id: panelRow
		anchors.fill: parent
		anchors.leftMargin: 24
		anchors.rightMargin: 24
		anchors.topMargin: 8
		anchors.bottomMargin: 8

		Repeater {
			model: workspaces
			delegate: Text {
				required property var modelData
				required property int index
				property bool isActive: modelData.is_focused
				text: modelData.name ?? String(modelData.idx ?? index + 1)
				color: isActive ? yellow : (modelData.is_active ? aqua : bg3)
				font { pixelSize: 16; bold: true }

				MouseArea {
					anchors.fill: parent
					onClicked: {
						focusWs.command = ["niri", "msg", "action", "focus-workspace", String(modelData.idx ?? modelData.id)]
						focusWs.running = false
						focusWs.running = true
					}
				}
			}
		}

		Item { Layout.fillWidth: true }
			Repeater {
				model: SystemTray.items 
				delegate: Item {
					id: trayItem
					required property SystemTrayItem modelData
					width: 20
					height: 20

					Image {
						anchors.centerIn: parent
						source: modelData.icon
						width: 16
						height: 16
						smooth: true

						MouseArea {
							anchors.fill: parent
							acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
							onWheel: wheel => modelData.scroll(
								wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.angleDelta.x,
								wheel.angleDelta.y === 0
							)
							onClicked: mouse => {
								if (mouse.button === Qt.MiddleButton) {
									modelData.secondaryActivate()
									return
								}

								if (mouse.button === Qt.RightButton) {
									if (modelData.hasMenu) {
										modelData.display(
											root,
											panelRow.x + trayItem.x,
											panelRow.y + trayItem.y + trayItem.height
										)
									} else {
										modelData.secondaryActivate()
									}

									return
								}

								if (modelData.onlyMenu && modelData.hasMenu) {
									modelData.display(
										root,
										panelRow.x + trayItem.x,
										panelRow.y + trayItem.y + trayItem.height
									)
									return
								}

								modelData.activate()
							}
						}
					}
				}
			}

		Item { width: 8 }
		Text {
			text: "↓ " + rxSpeed
			color: orange
			font { pixelSize: 14; bold: true }
		}

		Item { width: 8 }
		Text {
			text: "↑ " + txSpeed
			color: purple
			font { pixelSize: 14; bold: true }
		}


		Item { width: 8 }
		Text {
			text: "CPU: " + cpuUsage + "%"
			color: cpuUsage > 80 ? yellow : aqua
			font { pixelSize: 14; bold: true }
		}

		Item { width: 8 }
		Text {
			text: "RAM: " + memUsage + "%"
			color: memUsage > 80 ? yellow : green
			font { pixelSize: 14; bold: true }
		}
	}

	Item {
		anchors.centerIn: parent

		Column {
			anchors.centerIn: parent
			spacing: 0

			Text {
				anchors.horizontalCenter: parent.horizontalCenter
				text: clockTime
				color: fg 
				font { pixelSize: 16; bold: true }
			}
			Text {
				anchors.horizontalCenter: parent.horizontalCenter
				text: clockDate
				color: bg3
				font { pixelSize: 11 }
			}
		}
	}

	Process {
		id: focusWs
		command: []
	}

	Process {
		id: cpuProc
		command: ["sh", "-c", "head -1 /proc/stat"]
		stdout: SplitParser {
			onRead: data => {
				if (!data) return
				var p = data.trim().split(/\s+/)
				var idle = parseInt(p[4]) + parseInt(p[5])
				var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
				if (lastCpuTotal > 0) {
					cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)))
				}

				lastCpuTotal = total
				lastCpuIdle = idle
			}
		}
	}

	Process {
		id: memProc
		command: ["sh", "-c", "awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf \"%d\", int(100*(t-a)/t)}' /proc/meminfo"]
		stdout: SplitParser {
			onRead: data => {
				const v = parseInt(data)
				if (!isNaN(v)) memUsage = v
			}
		}
	}

	Timer {
		interval: 2000
		running: true
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			cpuProc.running = false
			cpuProc.running = true
			memProc.running = false
			memProc.running = true
			netProc.running = false
			netProc.running = true

		}
	}
}
