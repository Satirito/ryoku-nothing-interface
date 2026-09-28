import QtQuick
import Quickshell
import Quickshell.Io
import shell.services as Svc

Item {
    id: rootMod
    required property var root
    signal activated()

    readonly property date now: clk.date
    readonly property string tooltipText: now.toLocaleDateString(Svc.Config.formatLoc, Locale.LongFormat)
    readonly property string timeStr: root.clock12h
        ? String((now.getHours() % 12) || 12).padStart(2, "0") + ":" + String(now.getMinutes()).padStart(2, "0")
        : String(now.getHours()).padStart(2, "0") + ":" + String(now.getMinutes()).padStart(2, "0")
    implicitWidth: display.implicitWidth
    implicitHeight: 28

    SystemClock { id: clk; precision: SystemClock.Minutes }

    Text {
        id: display
        anchors.centerIn: parent
        text: rootMod.timeStr
        color: "#F5F5F5"
        font.family: "Noto Sans"
        font.pixelSize: 15
    }

    TooltipMixin { id: tip; root: rootMod.root; owner: rootMod; text: rootMod.tooltipText }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onEntered: tip.show()
        onExited: tip.hide()
        onClicked: (event) => {
            tip.hide()
            if (event.button === Qt.RightButton) root.clock12h = !root.clock12h
            else rootMod.activated()
        }
    }
}
