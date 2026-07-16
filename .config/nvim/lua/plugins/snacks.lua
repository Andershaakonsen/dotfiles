return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  -- <leader>ff and <leader>fs are now owned by fff.nvim (see plugins/fff.lua),
  -- so nothing is overridden here anymore. LazyVim's snacks_picker binds for
  -- those keys are superseded by fff's `keys` (loaded after).
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

    -- <leader>e opens the Snacks explorer (built on the picker). It hides
    -- dotfiles and gitignored files by default. Show them ONLY in this
    -- dotfiles repo — everywhere else keep the normal hidden defaults.
    -- (Checked against the launch cwd, since snacks loads at startup. Inside
    -- the explorer you can still toggle hidden/ignored manually.)
    local dotfiles = vim.fn.expand("~/dotfiles")
    if vim.fn.getcwd():sub(1, #dotfiles) == dotfiles then
      opts.picker.sources = {
        explorer = {
          hidden = true, -- show dotfiles (.config, .gitignore, .zshrc, ...)
          ignored = true, -- show gitignored files (CLAUDE.md, ...)
          exclude = { ".git", ".DS_Store" }, -- but never show these
        },
      }
    end

    return opts
  end,
}
