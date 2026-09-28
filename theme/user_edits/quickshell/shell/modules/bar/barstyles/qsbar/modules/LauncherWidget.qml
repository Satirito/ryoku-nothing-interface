import QtQuick
import Quickshell
import Ryoku.Ui.Singletons
import shell.services

Item {
    id: rootMod
    required property var root
    readonly property real logoPadding: 12
    implicitWidth: 32
    implicitHeight: 28

    readonly property string tooltipText: Config.launcherTarget === "quick"
        ? I18n.tr("Quick settings") : I18n.tr("Control center")
    Grid {
        anchors.centerIn: parent
        columns: 2
        spacing: 2
        Repeater {
            model: 4
            Rectangle {
                required property int index
                width: 6
                height: 6
                radius: 3
                color: clicker.containsMouse ? "#FFFFFF"
                    : index === 3 ? "#B1B3B3" : "#F5F5F5"
            }
        }
    }

    TooltipMixin { id: tip; root: rootMod.root; owner: rootMod; text: rootMod.tooltipText }

    MouseArea {
        id: clicker
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: tip.show()
        onExited: tip.hide()
        onClicked: {
            tip.hide()
            if (Config.launcherTarget === "quick")
                ShellState.requestSurfaceActive("quick-settings", undefined)
            else
                root.controlVisible = !root.controlVisible
        }
    }
}
