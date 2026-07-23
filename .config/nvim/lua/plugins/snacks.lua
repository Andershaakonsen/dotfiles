return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  -- <leader>ff and <leader>fs are now owned by fff.nvim (see plugins/fff.lua),
  -- so nothing is overridden here anymore. LazyVim's snacks_picker binds for
  -- those keys are superseded by fff's `keys` (loaded after).
  --
  -- Pin <leader>e to the launch cwd, NOT LazyVim.root(). LazyVim's default
  -- <leader>e -> Snacks.explorer({ cwd = LazyVim.root() }) re-detects the root
  -- from the current file, so opening e.g. a workflow yml (whose LSP root_dir
  -- is a subdir) yanks the explorer down into that subdir. cwd is stable for
  -- the whole session and matches the project you opened nvim in.
  --
  -- <leader>uC: LazyVim points this at the Snacks-picker colorscheme picker,
  -- which is dead here (picker disabled). Re-point it at Telescope's builtin
  -- colorscheme picker with live preview. This drives no file previewer window,
  -- so it's crash-safe even though Telescope's previewer is off elsewhere.
  --
  -- The explorer's `H` / `<a-h>` hidden-files toggle is persisted to a state
  -- file so it survives explorer reopens and nvim restarts (see opts below).
  keys = {
    { "<leader>e", function() Snacks.explorer() end, desc = "Explorer (cwd)" },
    { "<leader>fe", function() Snacks.explorer() end, desc = "Explorer (cwd)" },
    {
      "<leader>uC",
      function()
        require("telescope.builtin").colorscheme({ enable_preview = true })
      end,
      desc = "Colorscheme (preview)",
    },
  },
  ---@type snacks.Config
  opts = function(_, opts)
    -- Absolute minimal config to avoid TUI crashes
    opts.bigfile = { enabled = false }
    opts.animate = { enabled = false }
    opts.dashboard = { enabled = false }
    opts.explorer = { enabled = false }
    opts.indent = { enabled = false }
    opts.input = { enabled = false }
    opts.picker = { enabled = false }
    opts.notifier = { enabled = false }
    opts.quickfile = { enabled = false }
    opts.scope = { enabled = false }
    opts.scroll = { enabled = false }
    opts.statuscolumn = { enabled = false } -- Disabled: use native instead
    opts.words = { enabled = false }

    -- === Persisted "show hidden files" toggle for the Snacks explorer ===
    -- Snacks resets the hidden/ignored toggles every time the explorer opens
    -- (state lives only on the live picker instance). Persist the `hidden`
    -- state to a small state file so pressing `H` / `<a-h>` sticks across
    -- explorer reopens AND nvim restarts.
    local state_file = vim.fn.stdpath("state") .. "/snacks-explorer-hidden"

    local function read_hidden()
      local f = io.open(state_file, "r")
      if not f then
        return false
      end
      local v = f:read("*l")
      f:close()
      return v == "true"
    end

    local function write_hidden(v)
      local f = io.open(state_file, "w")
      if f then
        f:write(v and "true" or "false")
        f:close()
      end
    end

    -- <leader>e opens the Snacks explorer (built on the picker). In ~/dotfiles
    -- keep the long-standing always-on behavior: show dotfiles AND gitignored
    -- files (CLAUDE.md, ...). Everywhere else, honor the persisted `hidden`
    -- toggle; gitignored files stay hidden. (cwd is checked at startup, since
    -- snacks loads eagerly.)
    local dotfiles = vim.fn.expand("~/dotfiles")
    local in_dotfiles = vim.fn.getcwd():sub(1, #dotfiles) == dotfiles

    -- === satoru-only explorer excludes (toggleable with H) ===
    -- Inside the satoru vault, hide these structural folders/files from the
    -- explorer by default (NOT gitignore — they stay on disk and tracked).
    -- They are tied to the `hidden` toggle: pressing H / <a-h> reveals them
    -- (along with dotfiles). Add more names to the list below.
    local satoru = vim.fn.expand("~/satoru")
    local cwd = vim.fn.getcwd()
    local in_satoru = cwd == satoru or cwd:sub(1, #satoru + 1) == satoru .. "/"
    local satoru_extra = in_satoru
        and {
          "Archive",
          "Excalidraw",
          "assets",
          "scripts",
          "CLAUDE.md",
          "index.md",
        }
      or {}

    -- Build the exclude list from the current `hidden` state: when hidden items
    -- are shown, the structural entries are revealed too (so H toggles both).
    local function compute_exclude(hidden)
      local ex = { ".git", ".DS_Store" } -- never show these (everywhere)
      if not hidden then
        vim.list_extend(ex, satoru_extra)
      end
      return ex
    end

    local initial_hidden = in_dotfiles or read_hidden()

    -- Custom action name (deliberately NOT one of Snacks' built-in `toggles`
    -- keys, so it won't be clobbered by the generic toggle-action generator in
    -- snacks/picker/config/init.lua). Mirrors the built-in toggle_hidden — flip
    -- `hidden`, re-target, re-find — plus persist the value AND recompute the
    -- exclude list so the satoru structural entries toggle together with it.
    local function toggle_hidden_persist(picker)
      picker.opts.hidden = not picker.opts.hidden
      write_hidden(picker.opts.hidden)
      picker.opts.exclude = compute_exclude(picker.opts.hidden)
      picker.list:set_target()
      picker:find()
    end

    opts.picker.sources = {
      explorer = {
        hidden = initial_hidden,
        ignored = in_dotfiles, -- gitignored files: only in the dotfiles repo
        exclude = compute_exclude(initial_hidden),
        actions = { toggle_hidden_persist = toggle_hidden_persist },
        win = {
          list = {
            keys = {
              ["H"] = "toggle_hidden_persist",
              ["<a-h>"] = "toggle_hidden_persist",
            },
          },
        },
      },
    }

    return opts
  end,
}
