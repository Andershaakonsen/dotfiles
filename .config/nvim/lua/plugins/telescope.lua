return {
  "nvim-telescope/telescope.nvim",
  tag = "v0.1.9",

  lazy = false, -- Force load immediately to prevent crash on lazy load
  priority = 1000, -- Load early
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    -- Override LazyVim's <leader>ff keymap with NO preview
    {
      "<leader>ff",
      function()
        -- Match the explorer: in the dotfiles repo show dotfiles + gitignored
        -- files; everywhere else keep telescope's normal hidden defaults.
        -- .git/ and .DS_Store are always filtered out.
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
    -- Add live_grep keymap (no preview to prevent TUI crashes)
    {
      "<leader>fs",
      function()
        require("telescope.builtin").live_grep({
          previewer = false,
        })
      end,
      desc = "Find String (no preview)",
    },
  },
  opts = function()
    local actions = require("telescope.actions")

    return {
      defaults = {
        -- Exclude binary and problematic files
        file_ignore_patterns = {
          "%.spl$", -- Vim spell files (binary)
          "%.bin$",
          "%.exe$",
          "%.dll$",
          "%.so$",
          "%.dylib$",
          "%.class$",
          "%.pyc$",
          "node_modules/",
          ".git/",
        },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          previewer = false, -- Disable preview for find_files
        },
        live_grep = {
          previewer = false, -- Disable preview for live_grep (prevents TUI crashes)
        },
      },
    }
  end,
}
