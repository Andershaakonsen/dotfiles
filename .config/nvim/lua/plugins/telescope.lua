return {
  "nvim-telescope/telescope.nvim",
  tag = "v0.1.9",

  lazy = false, -- Force load immediately to prevent crash on lazy load
  priority = 1000, -- Load early
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- NOTE: <leader>ff and <leader>fs are defined in lua/config/keymaps.lua, not
  -- here. LazyVim's own picker spec also binds <leader>ff and wins over a plugin
  -- spec's `keys`, so the overrides must live in config.keymaps (loaded later).
  opts = function()
    local actions = require("telescope.actions")

    return {
      defaults = {
        -- Put the prompt at the top; ascending so the best match sits right
        -- under it (otherwise results fill from the bottom up).
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
        },
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
