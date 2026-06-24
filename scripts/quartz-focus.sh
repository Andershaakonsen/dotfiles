#!/usr/bin/env bash
# Fokuser Quartz-fanen i Chrome hvis den er åpen; ellers åpne den i ny fane.
# Bundet til ctrl-q i AeroSpace (~/.aerospace.toml).
set -euo pipefail

URL="http://quartz:8088/"
MATCH="quartz:8088"

osascript - "$URL" "$MATCH" <<'APPLESCRIPT'
on run argv
  set targetURL to item 1 of argv
  set matchStr to item 2 of argv
  tell application "Google Chrome"
    set found to false
    repeat with w in windows
      set i to 0
      repeat with t in tabs of w
        set i to i + 1
        if (URL of t) contains matchStr then
          set active tab index of w to i
          set index of w to 1
          set found to true
          exit repeat
        end if
      end repeat
      if found then exit repeat
    end repeat
    if not found then
      if (count of windows) is 0 then make new window
      tell front window to make new tab with properties {URL:targetURL}
    end if
    activate
  end tell
end run
APPLESCRIPT
