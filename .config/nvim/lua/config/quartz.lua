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
local CHROME_REUSE = [[
on run argv
  set targetURL to item 1 of argv
  set matchStr to item 2 of argv
  tell application "Google Chrome"
    set didReuse to false
    repeat with w in windows
      set i to 0
      repeat with t in tabs of w
        set i to i + 1
        if (URL of t) contains matchStr then
          set URL of t to targetURL
          set active tab index of w to i
          set index of w to 1
          set didReuse to true
          exit repeat
        end if
      end repeat
      if didReuse then exit repeat
    end repeat
    if not didReuse then
      if (count of windows) is 0 then make new window
      tell front window to make new tab with properties {URL:targetURL}
    end if
    activate
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

-- Open the URL, reusing an existing Quartz tab in Chrome when possible.
-- Falls back to the system opener if Chrome scripting fails. Shows a spinner
-- tied to the osascript job's lifetime (kept up for a short minimum so it
-- doesn't just flash).
local function open_url(url)
  local stop = show_spinner("Åpner i Quartz…")
  local started = uv.now()
  local MIN_MS = 450
  vim.fn.jobstart({ "osascript", "-e", CHROME_REUSE, url, HOST_MATCH }, {
    on_exit = function(_, code)
      local wait = math.max(0, MIN_MS - (uv.now() - started))
      vim.defer_fn(function()
        stop()
        if code ~= 0 then
          if vim.ui.open then
            vim.ui.open(url)
          else
            vim.fn.jobstart({ "open", url }, { detach = true })
          end
        end
      end, wait)
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
