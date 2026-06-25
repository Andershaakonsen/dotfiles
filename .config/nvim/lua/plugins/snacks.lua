return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  -- snacks.nvim owns <leader>ff/<leader>fs (LazyVim's default picker registers
  -- them via the snacks_picker extra). Overriding them here — on the same plugin
  -- spec — lets lazy.nvim merge the `keys` and our fragment win. Putting them on
  -- the telescope spec (a different plugin) does NOT work: both get set and
  -- whichever plugin loads last wins, which was snacks.
  keys = {
    {
      "<leader>ff",
      function()
        -- Match the explorer: in the dotfiles repo show dotfiles + gitignored
        -- files; everywhere else keep telescope's normal hidden defaults. .git/
        -- and .DS_Store are always filtered out.
        local dotfiles = vim.fn.expand("~/dotfiles")
        local in_dotfiles = vim.fn.getcwd():sub(1, #dotfiles) == dotfiles
        require("telescope.builtin").find_files({
          previewer = false,
          hidden = in_dotfiles, -- show dotfiles (.config, .gitignore, ...)
          no_ignore = in_dotfiles, -- show gitignored files (CLAUDE.md, ...)
          file_ignore_patterns = { "%.spl$", "%.bin$", "%.exe$", "node_modules/", "%.git/", "%.DS_Store$" },
        })
      end,
      desc = "Find Files (no preview)",
    },
    {
      "<leader>fs",
      function()
        require("telescope.builtin").live_grep({ previewer = false })
      end,
      desc = "Find String (no preview)",
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
