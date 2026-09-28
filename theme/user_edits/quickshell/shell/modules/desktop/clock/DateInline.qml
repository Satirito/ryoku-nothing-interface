pragma ComponentBehavior: Bound
import QtQuick
import "../Singletons"
import "lib/clock.js" as Clk
import shell.services as Svc

// Compact Russian date under the dot clock, styled after the phone reference.
Item {
    id: date

    // the widget floats on the wallpaper, so its ink is picked against the patch
    // of picture under it. WidgetSlot measures it and pushes it in.
    property real underL: Scheme.wallLstar
    // a pinned colour ("" = follow wallpaper) paints this strip's own ink.
    property string inkColorA: ""
    readonly property color ink:     Theme.inkOn2(date.underL, date.inkColorA)
    readonly property color inkDim:  Theme.inkDimOn2(date.underL, date.inkColorA)
    readonly property color inkSoft: Theme.inkSoftOn2(date.underL, date.inkColorA)

    readonly property var dp: Clk.dateParts(Now.date, Qt.locale("ru_RU"))
    readonly property color accent: Clk.pickAccent(Config.clockAccent, Theme.accentOn2(date.underL, date.inkColorA), Theme.brand, date.ink)
    readonly property real px: Math.round(22 * Config.clockScale)

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        spacing: Math.round(7 * Config.clockScale)

        Text {
            text: date.dp.weekdayShort.charAt(0).toUpperCase() + date.dp.weekdayShort.slice(1) + ","
            color: date.accent
            font.family: "Noto Sans"
            font.pixelSize: date.px
            font.weight: Font.Normal
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: date.dp.dom + " " + date.dp.monthShort
            color: date.inkSoft
            font.family: "Noto Sans"
            font.pixelSize: date.px
            font.weight: Font.Normal
        }
    }
}
