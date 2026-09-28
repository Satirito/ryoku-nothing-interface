pragma ComponentBehavior: Bound
import QtQuick
import "../Singletons"
import "lib/clock.js" as Clk

Item {
    id: face
    property real underL: Scheme.wallLstar
    property string inkColorA: ""
    readonly property var t: Clk.parts(Now.date, Config.clock24h)
    readonly property int step: Math.round(11 * Config.clockScale)
    readonly property real dotRadius: step * 0.52
    readonly property real gap: step * 0.75
    readonly property real digitWidth: 5 * step
    readonly property real dotWidth: 4 * digitWidth + 4 * gap + 2 * step
    readonly property bool side: Config.clockSeconds || !Config.clock24h
    implicitWidth: dotWidth + (side ? 63 * Config.clockScale : 0)
    implicitHeight: 7 * step
    onTChanged: digits.requestPaint()
    onStepChanged: digits.requestPaint()

    Canvas {
        id: digits
        width: face.dotWidth
        height: face.implicitHeight
        antialiasing: true
        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            const patterns = {
                "0": ["01110", "10001", "10001", "10001", "10001", "10001", "01110"],
                "1": ["00100", "01100", "00100", "00100", "00100", "00100", "01110"],
                "2": ["01110", "10001", "00001", "00110", "01000", "10000", "11111"],
                "3": ["11110", "00001", "00001", "01110", "00001", "00001", "11110"],
                "4": ["10010", "10010", "10010", "11111", "00010", "00010", "00010"],
                "5": ["11111", "10000", "10000", "11110", "00001", "00001", "11110"],
                "6": ["01111", "10000", "10000", "11110", "10001", "10001", "01110"],
                "7": ["11111", "00001", "00010", "00100", "01000", "01000", "01000"],
                "8": ["01110", "10001", "10001", "01110", "10001", "10001", "01110"],
                "9": ["01110", "10001", "10001", "01111", "00001", "00001", "11110"]
            }
            function dot(x, y, color) {
                ctx.beginPath()
                ctx.arc(x, y, face.dotRadius, 0, Math.PI * 2)
                ctx.fillStyle = color
                ctx.fill()
            }
            function digit(ch, start, color) {
                const rows = patterns[ch] || patterns["0"]
                for (let r = 0; r < 7; r++)
                    for (let c = 0; c < 5; c++)
                        if (rows[r][c] === "1")
                            dot(start + c * face.step + face.dotRadius,
                                r * face.step + face.dotRadius, color)
            }
            const hh = String(face.t.hh).padStart(2, "0")
            const mm = String(face.t.mm).padStart(2, "0")
            const white = "#F5F5F5"
            const muted = "#C2C4CB"
            const x1 = face.digitWidth + face.gap
            const colonX = x1 + face.digitWidth + face.gap
            const x2 = colonX + 2 * face.step + face.gap
            const x3 = x2 + face.digitWidth + face.gap
            digit(hh[0], 0, white)
            digit(hh[1], x1, white)
            dot(colonX + face.step, face.step * 2 + face.dotRadius, white)
            dot(colonX + face.step, face.step * 4 + face.dotRadius, white)
            digit(mm[0], x2, muted)
            digit(mm[1], x3, muted)
        }
    }

    Text {
        visible: face.side
        x: face.dotWidth + 12 * Config.clockScale
        anchors.verticalCenter: digits.verticalCenter
        text: Config.clockSeconds ? face.t.ss : face.t.ampm
        color: "#C2C4CB"
        font.family: "NType 82"
        font.styleName: "Regular"
        font.pixelSize: Math.round(20 * Config.clockScale)
    }
}
