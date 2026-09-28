# Nothing Media

The preview image is a schematic illustration. It contains no wallpaper,
album art, track title or playback history.

A larger charcoal music widget with a neutral geometric record. It displays
the currently selected MPRIS player's title, artist, progress and song text.
Synced lines follow the playback position; plain lyrics remain still. When
the song has no text, the card says so. The button toggles play/pause.

The service polls `bin/media.py` every two seconds. It reads local MPRIS
metadata through `playerctl`, then subscribes to `ryoku-shell.sock` for the
same lyrics frame as Ryoku's original desktop music widget. Ryoku's daemon
owns any lyric lookup; this plugin makes no network requests. It writes no
files and needs no privileges.
