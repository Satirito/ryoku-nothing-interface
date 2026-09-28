import QtQuick

Rectangle {
    id: root
    property var pluginApi
    property var screen
    property bool active: false
    property string density: "compact"
    property real s: 1
    property real widthBudget: 0
    readonly property var service: pluginApi ? pluginApi.mainInstance : null
    readonly property var state: service ? service.data : ({})
    readonly property var frame: service ? service.lyricFrame : ({})
    readonly property bool available: state.available === true
    readonly property bool playing: state.playing === true
    readonly property string titleText: available ? (state.title || "Музыка") : "Ничего не играет"
    readonly property string artistText: available ? (state.artist || " ") : " "
    readonly property real position: Number(state.position || 0)
    readonly property real length: Number(state.length || 0)
    readonly property bool lyricsMatch: available && String(frame.title || "")
        .toLocaleLowerCase().startsWith(String(state.title || "").toLocaleLowerCase())
    readonly property string lyricsStatus: lyricsMatch ? String(frame.lyricsStatus || "idle") : "loading"
    readonly property var syncedLines: lyricsStatus === "ok" && Array.isArray(frame.lyrics)
        ? frame.lyrics : []
    readonly property var plainLines: lyricsStatus === "plain" && Array.isArray(frame.plain)
        ? frame.plain : []
    readonly property int activeLine: {
        let found = 0
        for (let i = 0; i < syncedLines.length; i++) {
            if (Number(syncedLines[i].t) <= position) found = i
            else break
        }
        return found
    }

    function lineAt(index) {
        if (index < 0 || index >= syncedLines.length) return ""
        return String(syncedLines[index].text || "♪")
    }
    function stamp(seconds) {
        const n = Math.max(0, Math.floor(seconds))
        return String(Math.floor(n / 60)) + ":" + String(n % 60).padStart(2, "0")
    }

    implicitWidth: 320 * s
    implicitHeight: 320 * s
    width: implicitWidth
    height: implicitHeight
    radius: 32 * s
    color: "#1C1D21"

    Canvas {
        x: 16 * root.s
        y: 16 * root.s
        width: 132 * root.s
        height: 132 * root.s
        antialiasing: true
        onPaint: {
            const c = getContext("2d")
            c.clearRect(0, 0, width, height)
            c.save()
            c.scale(root.s, root.s)
            c.beginPath(); c.arc(66, 66, 62, 0, Math.PI * 2)
            c.fillStyle = "#303136"; c.fill()
            c.strokeStyle = "#515258"; c.lineWidth = 1.5
            for (const r of [48, 35, 22]) {
                c.beginPath(); c.arc(66, 66, r, 0, Math.PI * 2); c.stroke()
            }
            c.beginPath(); c.arc(66, 66, 7, 0, Math.PI * 2)
            c.fillStyle = "#DCD7D2"; c.fill()
            c.restore()
        }
    }

    Text {
        x: 157 * root.s; y: 20 * root.s
        width: 146 * root.s; height: 58 * root.s
        text: root.titleText
        color: "#F5F5F5"
        font.family: "Noto Sans"
        font.pixelSize: 16 * root.s
        font.weight: Font.Medium
        wrapMode: Text.WordWrap
        maximumLineCount: 3
        elide: Text.ElideRight
    }
    Text {
        x: 157 * root.s; y: 85 * root.s
        width: 146 * root.s
        text: root.artistText
        color: "#B1B3B3"
        font.family: "Noto Sans"
        font.pixelSize: 12 * root.s
        elide: Text.ElideRight
    }
    Text {
        x: 157 * root.s; y: 117 * root.s
        text: root.available ? root.stamp(root.position) + " / " + root.stamp(root.length) : ""
        color: "#B1B3B3"
        font.family: "Noto Sans"
        font.pixelSize: 11 * root.s
    }
    Rectangle {
        id: playButton
        x: 269 * root.s; y: 109 * root.s
        width: 36 * root.s; height: 36 * root.s
        radius: width / 2
        color: "#303136"
        opacity: root.available ? 1 : 0.5
        Canvas {
            id: playMark
            anchors.fill: parent
            onPaint: {
                const c = getContext("2d")
                c.clearRect(0, 0, width, height)
                c.save(); c.scale(root.s, root.s)
                c.fillStyle = "#F5F5F5"
                if (root.playing) {
                    c.fillRect(12, 10, 4, 16)
                    c.fillRect(20, 10, 4, 16)
                } else {
                    c.beginPath(); c.moveTo(13, 9)
                    c.lineTo(26, 18); c.lineTo(13, 27)
                    c.closePath(); c.fill()
                }
                c.restore()
            }
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: if (root.service) root.service.togglePlayback()
        }
    }
    onPlayingChanged: playMark.requestPaint()

    Rectangle {
        id: lyricPlate
        x: 16 * root.s; y: 158 * root.s
        width: 288 * root.s; height: 120 * root.s
        radius: 20 * root.s
        color: "#303136"
        clip: true

        Column {
            visible: root.syncedLines.length > 0
            x: 14 * root.s; y: 17 * root.s
            width: parent.width - 28 * root.s
            spacing: 5 * root.s
            Text {
                width: parent.width
                visible: text.length > 0
                text: root.lineAt(root.activeLine - 1)
                color: "#B1B3B3"; opacity: 0.55
                font.family: "Noto Sans"; font.pixelSize: 12 * root.s
                elide: Text.ElideRight
            }
            Text {
                width: parent.width
                text: root.lineAt(root.activeLine)
                color: "#F5F5F5"
                font.family: "Noto Sans"; font.pixelSize: 15 * root.s
                font.weight: Font.Medium
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }
            Text {
                width: parent.width
                visible: text.length > 0
                text: root.lineAt(root.activeLine + 1)
                color: "#B1B3B3"; opacity: 0.7
                font.family: "Noto Sans"; font.pixelSize: 12 * root.s
                elide: Text.ElideRight
            }
        }
        Text {
            visible: root.plainLines.length > 0 && root.syncedLines.length === 0
            x: 14 * root.s; y: 15 * root.s
            width: parent.width - 28 * root.s
            height: parent.height - 30 * root.s
            text: root.plainLines.slice(0, 4).join("\n")
            color: "#F5F5F5"
            font.family: "Noto Sans"; font.pixelSize: 13 * root.s
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }
        Text {
            anchors.centerIn: parent
            visible: root.plainLines.length === 0 && root.syncedLines.length === 0
            width: parent.width - 24 * root.s
            horizontalAlignment: Text.AlignHCenter
            text: !root.available ? "Включите музыку"
                : root.lyricsStatus === "loading" ? "Ищем текст песни…"
                : root.lyricsStatus === "error" ? "Текст недоступен"
                : "Текст песни не найден"
            color: "#B1B3B3"
            font.family: "Noto Sans"; font.pixelSize: 13 * root.s
        }
    }

    Rectangle {
        x: 18 * root.s; y: 294 * root.s
        width: 284 * root.s; height: 3 * root.s
        radius: height / 2
        color: "#4B4C52"
        Rectangle {
            width: parent.width * (root.length > 0
                ? Math.max(0, Math.min(1, root.position / root.length)) : 0)
            height: parent.height
            radius: parent.radius
            color: "#DCD7D2"
        }
    }
}
