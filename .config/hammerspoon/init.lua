-- Hammerspoon: alt-drag to move/resize floating windows.
--
-- Mirrors the old yabai mouse config that AeroSpace can't replicate natively
-- (AeroSpace is keyboard-only, no mouse_action/resize config exists):
--   mouse_modifier = alt
--   mouse_action1  = move    -> alt + LEFT-drag
--   mouse_action2  = resize  -> alt + RIGHT-drag
--
-- Only meaningful for FLOATING windows. AeroSpace re-tiles managed windows
-- immediately, so dragging a tiled window just snaps back — expected.

-- Start the IPC command server so the `hs` CLI (`hs -c "..."`) works — used to
-- reload config and drive Hammerspoon from scripts. Without this, `hs -c` hangs.
require("hs.ipc")

local eventtap = hs.eventtap
local etypes = eventtap.event.types

-- TEMP debug: appends to /tmp/hs-altdrag.log so we can see where the drag breaks.
local function dbg(msg)
  local f = io.open("/tmp/hs-altdrag.log", "a")
  if f then
    f:write(msg .. "\n")
    f:close()
  end
end

-- No animation: frames must track the cursor 1:1.
hs.window.animationDuration = 0

-- Active drag state, or nil when idle.
-- { win = <hs.window>, kind = "move"|"resize", mouse0 = {x,y}, frame0 = <rect> }
local drag = nil

-- True only when alt is the *sole* held modifier (matches yabai's single-mod behavior).
local function altOnly()
  local m = eventtap.checkKeyboardModifiers()
  return m.alt and not (m.cmd or m.ctrl or m.shift or m.fn)
end

-- Topmost standard window whose frame contains the cursor.
local function windowUnderMouse()
  local p = hs.mouse.absolutePosition()
  for _, w in ipairs(hs.window.orderedWindows()) do
    if w:isStandard() and not w:isFullScreen() then
      local f = w:frame()
      if p.x >= f.x and p.x <= f.x + f.w and p.y >= f.y and p.y <= f.y + f.h then
        return w
      end
    end
  end
  return nil
end

-- IMPORTANT: eventtaps must live in a persistent (non-local) variable, or Lua's
-- garbage collector reaps them after init.lua returns and the taps go silent.
altDragTaps = altDragTaps or {}

altDragTaps.down = eventtap.new({ etypes.leftMouseDown, etypes.rightMouseDown }, function(e)
  local m = eventtap.checkKeyboardModifiers()
  dbg("DOWN type=" .. tostring(e:getType()) .. " alt=" .. tostring(m.alt) .. " cmd=" .. tostring(m.cmd) .. " ctrl=" .. tostring(m.ctrl) .. " shift=" .. tostring(m.shift) .. " fn=" .. tostring(m.fn))
  if not altOnly() then
    dbg("  -> not altOnly, ignoring")
    return false
  end
  local w = windowUnderMouse()
  if not w then
    dbg("  -> no window under mouse")
    return false
  end
  local kind = (e:getType() == etypes.leftMouseDown) and "move" or "resize"
  drag = { win = w, kind = kind, mouse0 = hs.mouse.absolutePosition(), frame0 = w:frame() }
  dbg("  -> START " .. kind .. " on '" .. tostring(w:title()) .. "'")
  return true -- swallow the click so the app underneath doesn't react
end)

altDragTaps.move = eventtap.new({ etypes.leftMouseDragged, etypes.rightMouseDragged }, function()
  if not drag then
    dbg("DRAGGED but no active drag")
    return false
  end
  local p = hs.mouse.absolutePosition()
  local dx, dy = p.x - drag.mouse0.x, p.y - drag.mouse0.y
  local f = drag.frame0
  local want
  if drag.kind == "move" then
    want = { x = f.x + dx, y = f.y + dy, w = f.w, h = f.h }
  else
    want = { x = f.x, y = f.y, w = math.max(120, f.w + dx), h = math.max(80, f.h + dy) }
  end
  drag.win:setFrame(want)
  local got = drag.win:frame()
  dbg(string.format(
    "DRAG %s dx=%.0f dy=%.0f | frame0 w=%.0f h=%.0f | want w=%.0f h=%.0f | got x=%.0f y=%.0f w=%.0f h=%.0f",
    drag.kind, dx, dy, f.w, f.h, want.w, want.h, got.x, got.y, got.w, got.h
  ))
  return true
end)

altDragTaps.up = eventtap.new({ etypes.leftMouseUp, etypes.rightMouseUp }, function()
  if drag then
    drag = nil
    return true
  end
  return false
end)

altDragTaps.down:start()
altDragTaps.move:start()
altDragTaps.up:start()

-- Sync herdr's active-row highlight color to the macOS light/dark appearance.
-- herdr's [theme.custom] is a single global table (no light/dark split), so its
-- dark navy surface bleeds into light mode. A script rewrites config.toml and
-- hot-reloads herdr; we fire it on the system appearance-change event (event-
-- driven, no polling) and once now to match the current state.
-- Like the eventtaps above, the watcher must live in a persistent global or the
-- GC reaps it after init.lua returns.
local HERDR_THEME_SYNC = "/Users/andershakonsen/dotfiles/scripts/herdr-theme-sync.sh"
local function syncHerdrTheme()
  hs.task.new(HERDR_THEME_SYNC, nil):start()
end
herdrThemeWatcher = herdrThemeWatcher
  or hs.distributednotifications.new(syncHerdrTheme, "AppleInterfaceThemeChangedNotification")
herdrThemeWatcher:start()
syncHerdrTheme()

-- Surface whether accessibility is actually granted (taps silently no-op without it).
if hs.accessibilityState() then
  hs.alert.show("Hammerspoon: alt-drag move/resize aktiv")
else
  hs.alert.show("Hammerspoon MANGLER Accessibility-tilgang!")
end
