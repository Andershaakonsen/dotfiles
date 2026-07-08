-- Open the current vault note in the local Quartz site (http://quartz:8088).
--
-- Bound to <leader>q, but only as a *buffer-local* mapping for markdown files
-- inside the vault (see the autocmd at the bottom) — so it doesn't shadow
-- LazyVim's global <leader>q quit group anywhere else.
--
-- The note's URL is derived by replicating Quartz's own slugifyFilePath /
-- slugifyPath transform (quartz/util/path.ts), so the link matches what Quartz
-- actually emits:
--   lowercase · spaces → "-" · "&" → "-and-" · "%" → "-percent" ·
--   strip ? # < > : " | * · folder-note (Foo/Foo.md) → "foo/index".

local VAULT = "/Users/andershakonsen/satoru"
local BASE_URL = "http://quartz:8088"

-- Host:port used to recognise an already-open Quartz tab (derived from BASE_URL).
local HOST_MATCH = BASE_URL:gsub("^https?://", "")

-- AppleScript: if Chrome already has a Quartz tab open, navigate it (and focus
-- it) instead of opening a new tab; otherwise open a new tab. argv: url, match.
--
-- Raising the *correct* window across multiple Chrome windows: `set index to 1`
-- reorders Chrome's internal window list but is a well-known no-op for actually
-- raising the window visually — `activate` then surfaces the last-used window,
-- not the one we navigated. So we additionally AXRaise the target window via
-- System Events, matched by position (Chrome `bounds` -> AX `position`, stable
-- regardless of page-load timing). If Accessibility isn't granted the whole
-- System Events block errors and is caught, falling back to plain activate.
local CHROME_REUSE = [[
on run argv
  set targetURL to item 1 of argv
  set matchStr to item 2 of argv
  set winX to missing value
  set winY to missing value
  tell application "Google Chrome"
    set foundWin to missing value
    repeat with w in windows
      set i to 0
      repeat with t in tabs of w
        set i to i + 1
        if (URL of t) contains matchStr then
          set URL of t to targetURL
          set active tab index of w to i
          set foundWin to w
          exit repeat
        end if
      end repeat
      if foundWin is not missing value then exit repeat
    end repeat
    if foundWin is missing value then
      if (count of windows) is 0 then make new window
      tell front window to make new tab with properties {URL:targetURL}
      set foundWin to front window
    end if
    set index of foundWin to 1
    set b to bounds of foundWin
    set winX to item 1 of b
    set winY to item 2 of b
    activate
  end tell
  try
    tell application "System Events" to tell process "Google Chrome"
      set frontmost to true
      set best to missing value
      set bestDist to 100000000
      repeat with axWin in windows
        set p to position of axWin
        set dx to (item 1 of p) - winX
        set dy to (item 2 of p) - winY
        set dist to (dx * dx) + (dy * dy)
        if dist < bestDist then
          set bestDist to dist
          set best to axWin
        end if
      end repeat
      if best is not missing value then perform action "AXRaise" of best
    end tell
  end try
end run
]]

-- Under a tiling WM (AeroSpace) the reused Quartz tab may live in a Chrome
-- window on a *different* workspace, and neither `activate` nor AXRaise switches
-- workspace — so the note loads but you stay put. For that case we hand the
-- focusing to AeroSpace (`aerospace focus --window-id`, which switches workspace
-- AND focuses) and split the work in two: LOCATE finds the Quartz tab and makes
-- it active (so the window title == that tab, which is how we match it to an
-- AeroSpace window), then — after AeroSpace has focused it — NAVIGATE points it
-- at the new note. Navigating only *after* the match avoids racing Chrome's
-- title update. argv for both: the host:port match string (NAVIGATE also takes
-- the target URL). LOCATE prints the tab title, or "__QZ_NONE__" if not found.
local LOCATE_QUARTZ = [[
on run argv
  set matchStr to item 1 of argv
  tell application "Google Chrome"
    repeat with w in windows
      set i to 0
      repeat with t in tabs of w
        set i to i + 1
        if (URL of t) contains matchStr then
          set active tab index of w to i
          return title of t
        end if
      end repeat
    end repeat
  end tell
  return "__QZ_NONE__"
end run
]]

local NAVIGATE_QUARTZ = [[
on run argv
  set targetURL to item 1 of argv
  set matchStr to item 2 of argv
  tell application "Google Chrome"
    repeat with w in windows
      set i to 0
      repeat with t in tabs of w
        set i to i + 1
        if (URL of t) contains matchStr then
          set active tab index of w to i
          set URL of t to targetURL
          return
        end if
      end repeat
    end repeat
  end tell
end run
]]

local uv = vim.uv or vim.loop
local SPINNER = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

-- A small centered floating window with an animated spinner. Returns a function
-- that stops the animation and closes the window.
local function show_spinner(msg)
  local buf = vim.api.nvim_create_buf(false, true)
  local function line(frame)
    return "  " .. frame .. "  " .. msg .. "  "
  end
  local width = vim.fn.strdisplaywidth(line(SPINNER[1]))
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = width,
    height = 1,
    row = math.floor((vim.o.lines - 1) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    focusable = false,
    noautocmd = true,
    zindex = 250,
  })
  vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"

  local i, closed = 1, false
  local timer = uv.new_timer()
  local function render()
    if closed or not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { line(SPINNER[i]) })
    i = i % #SPINNER + 1
  end
  render()
  timer:start(90, 90, vim.schedule_wrap(render))

  return function()
    if closed then
      return
    end
    closed = true
    timer:stop()
    timer:close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

-- Whether AeroSpace is available (cached; nil = not yet probed).
local aero_ok = nil
local function has_aerospace()
  if aero_ok == nil then
    aero_ok = vim.fn.executable("aerospace") == 1
  end
  return aero_ok
end

-- Find the Chrome window whose title matches `title` and focus it via AeroSpace
-- (switches workspace + focuses). Returns true on a successful focus.
local function aerospace_focus_chrome(title)
  if not title or title == "" then
    return false
  end
  local out = vim.fn.systemlist({
    "aerospace", "list-windows", "--all",
    "--format", "%{window-id}\t%{app-name}\t%{window-title}",
  })
  if vim.v.shell_error ~= 0 then
    return false
  end
  for _, line in ipairs(out) do
    local id, app, wtitle = line:match("^(%d+)\t([^\t]*)\t(.*)$")
    if id and app == "Google Chrome" and wtitle:find(title, 1, true) then
      vim.fn.system({ "aerospace", "focus", "--window-id", id })
      return vim.v.shell_error == 0
    end
  end
  return false
end

-- Open the URL, reusing an existing Quartz tab in Chrome when possible.
-- Under AeroSpace: locate the tab, focus its window through AeroSpace, then
-- navigate it. Otherwise (or when no Quartz tab exists yet) fall back to the
-- all-in-one CHROME_REUSE script (activate + AXRaise), then the system opener.
-- A spinner is shown for a short minimum so it doesn't just flash.
local function open_url(url)
  local stop = show_spinner("Åpner i Quartz…")
  local started = uv.now()
  local MIN_MS = 450

  local function finish(after)
    local wait = math.max(0, MIN_MS - (uv.now() - started))
    vim.defer_fn(function()
      stop()
      if after then
        after()
      end
    end, wait)
  end

  -- Universal fallback: reuse-or-create tab + activate + AXRaise, then the OS
  -- opener if Chrome scripting failed entirely.
  local function fallback()
    vim.fn.jobstart({ "osascript", "-e", CHROME_REUSE, url, HOST_MATCH }, {
      on_exit = function(_, code)
        finish(function()
          if code ~= 0 then
            if vim.ui.open then
              vim.ui.open(url)
            else
              vim.fn.jobstart({ "open", url }, { detach = true })
            end
          end
        end)
      end,
    })
  end

  if not has_aerospace() then
    return fallback()
  end

  -- AeroSpace path: locate the existing Quartz tab and grab its title.
  local out = {}
  vim.fn.jobstart({ "osascript", "-e", LOCATE_QUARTZ, HOST_MATCH }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      out = data
    end,
    on_exit = function(_, code)
      local title = vim.trim(table.concat(out or {}, ""))
      if code ~= 0 or title == "" or title == "__QZ_NONE__" then
        return fallback() -- no existing Quartz tab, or the script failed
      end
      -- Focus via AeroSpace, retrying once to absorb its async title update
      -- (when the located tab wasn't already the window's active tab).
      local function try_focus(attempt)
        if aerospace_focus_chrome(title) then
          vim.fn.jobstart({ "osascript", "-e", NAVIGATE_QUARTZ, url, HOST_MATCH }, {
            on_exit = function()
              finish()
            end,
          })
        elseif attempt < 2 then
          vim.defer_fn(function()
            try_focus(attempt + 1)
          end, 120)
        else
          fallback()
        end
      end
      try_focus(1)
    end,
  })
end

-- Mirror of Quartz's slugifyPath() per-segment transform. Order matters.
local function slugify_segment(seg)
  seg = seg:gsub("%s", "-")
  seg = seg:gsub("&", "-and-")
  seg = seg:gsub("%%", "-percent")
  seg = seg:gsub("%?", "")
  seg = seg:gsub("#", "")
  seg = seg:gsub('[<>:"|*]', "")
  return seg:lower()
end

-- Mirror of Quartz's slugifyFilePath(): vault-relative path -> slug.
local function file_to_slug(rel)
  rel = rel:gsub("^/+", ""):gsub("/+$", "")

  -- Strip the extension. .md/.html become bare slugs; anything else is kept.
  local ext = rel:match("%.([%w]+)$")
  local without_ext, final_ext = rel, ""
  if ext then
    without_ext = rel:sub(1, #rel - #ext - 1)
    local e = ext:lower()
    if e ~= "md" and e ~= "html" then
      final_ext = "." .. ext
    end
  end

  -- Slugify each path segment.
  local segs = vim.split(without_ext, "/", { plain = true })
  for i, s in ipairs(segs) do
    segs[i] = slugify_segment(s)
  end
  local slug = (table.concat(segs, "/")):gsub("/$", "")

  -- "_index" -> "index"
  slug = slug:gsub("_index$", "index")

  -- Folder note: when the file name equals its parent folder (Foo/Foo.md),
  -- Quartz rewrites the last segment to "index".
  local parts = vim.split(slug, "/", { plain = true })
  local n = #parts
  if n >= 2 and parts[n] == parts[n - 1] then
    parts[n] = "index"
    slug = table.concat(parts, "/")
  end

  return slug .. final_ext
end

-- Current buffer path relative to the vault root, or nil if outside the vault.
local function buf_relpath()
  local abs = vim.fn.expand("%:p")
  if abs == "" then
    return nil
  end
  abs = vim.fn.resolve(abs)
  local vault = vim.fn.resolve(VAULT)
  if abs:sub(1, #vault + 1) ~= vault .. "/" then
    return nil
  end
  return abs:sub(#vault + 2)
end

local function open_in_quartz()
  local rel = buf_relpath()
  if not rel then
    vim.notify("Ikke i Quartz-vaultet", vim.log.levels.WARN)
    return
  end

  -- These are excluded from the Quartz build (see quartz.config.yaml
  -- ignorePatterns) — opening them would 404.
  if rel:match("^Anki/") or rel:match("%.excalidraw%.md$") or rel:match("^%.obsidian/") then
    vim.notify("Dette notatet publiseres ikke til Quartz:\n" .. rel, vim.log.levels.WARN)
    return
  end

  local slug = file_to_slug(rel)
  local url = BASE_URL .. "/" .. slug
  -- Folder-note / index slugs: navigate to the directory (avoids a redirect).
  url = url:gsub("/index$", "/")
  if slug == "index" or slug == "" then
    url = BASE_URL .. "/"
  end

  open_url(url)
end

-- Bind <leader>q buffer-locally for markdown files inside the vault only.
local group = vim.api.nvim_create_augroup("quartz_open", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = group,
  pattern = VAULT .. "/*.md",
  callback = function(ev)
    vim.keymap.set("n", "<leader>q", open_in_quartz, {
      buffer = ev.buf,
      desc = "Open note in Quartz",
      silent = true,
    })
  end,
})
