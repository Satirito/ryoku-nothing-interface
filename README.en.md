# Nothing Interface for Ryoku

**Charcoal surfaces. Dot-matrix clock. Island bar.** An unofficial [Ryoku](https://ryoku.dev) theme inspired by Nothing OS. [Русский README](README.md).

> A full desktop screenshot will be added later. No wallpaper or proprietary Nothing font files are bundled.

## What you get

- A three-island QS Bar, a four-dot launcher mark and monochrome status icons.
- A large QML-drawn dot clock and date, plus analog clock, battery, screen-time and media widgets.
- An optional circular audio widget. Red is reserved for the analog second hand and critical battery alerts.
- A fixed charcoal and grey palette that does not follow or replace your wallpaper.

| Analog clock | Battery | Screen time |
| :---: | :---: | :---: |
| <img src="plugins/nothing-analog-clock/assets/preview-widget.png" width="180" alt="Analog clock"> | <img src="plugins/nothing-dashboard/assets/preview-widget.png" width="180" alt="Battery tile"> | <img src="plugins/nothing-screen-time/assets/preview-widget.png" width="180" alt="Screen time"> |

| Media | Optional audio | Bar status |
| :---: | :---: | :---: |
| <img src="plugins/nothing-media/assets/preview-widget.png" width="180" alt="Schematic media tile without playback data"> | <img src="plugins/nothing-audio/assets/preview-widget.png" width="180" alt="Audio widget"> | <img src="plugins/nothing-status/assets/preview-widget.png" width="180" alt="Bar status"> |

## Install

Built with **Ryoku 0.75.3**. The four QML overrides may need updates with future Ryoku versions. Individual plugin manifests list their local command dependencies.

```bash
git clone https://github.com/venchik111/ryoku-nothing-interface.git
cd ryoku-nothing-interface
for name in nothing-analog-clock nothing-dashboard nothing-media nothing-screen-time; do
  ryoku plugin add "plugins/$name" --yes
done
ryoku plugin add plugins/nothing-status --bar --yes
ryoku-hub rice import "$PWD/theme"
ryoku-hub rice apply nothing-interface
ryoku-shell dock hide
```

Save your current Ryoku rice before applying the new one. The optional audio widget can be installed with `ryoku plugin add plugins/nothing-audio --yes`.

For the custom clock and launcher appearance, back up any existing `~/.config/ryoku/user_edits` directory, then copy `theme/user_edits/.` into it and run `ryoku reload`. These are user overlays; do not edit Ryoku's shipped files. If you already customized the same four QML files, preserve your changes before copying.

Place the plugins through **Ryoku Hub → Widgets**. [`theme/layout-example.json`](theme/layout-example.json) records a 1920 × 1080 reference layout and is not imported automatically. Set outer window gaps to **8** in **Ryoku Hub → Window Manager** if you want the same tight spacing. Adjust the islands in **QS Bar Settings → Bars / Layout / Community**. Restore a missing built-in bar clock with `ryoku-shell bar move clock --section center --index 0`.

The media tile reads local MPRIS metadata and Ryoku's lyrics feed. Screen time comes from Ryoku's own daily counter. Neither widget makes its own network requests.

## Fonts, wallpaper and license

The main font is **Noto Sans**; large dotted digits are drawn in QML. Optional NType 82 files can be obtained from the [Nothing community brand reference](https://nothing.wiki/nothing/brand_reference). Nothing's fonts and wallpapers are not redistributed here. [Nothing's Launcher Beta post](https://nothing.community/d/617-a-glimpse-of-nothing-os-nothing-launcher-beta-is-here) links to a wallpaper pack if you want one.

This is an independent fan project, unaffiliated with Nothing Technology Limited. Original plugins, preset and assets are [MIT licensed](LICENSE). The QML adaptations retain their upstream Ryoku licenses; see [NOTICE.md](NOTICE.md). Nothing trademarks, fonts and wallpapers belong to their respective owners.
