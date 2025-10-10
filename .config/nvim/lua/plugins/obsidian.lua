-- Obsidian plugin
return {
  {

    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    -- lazy = true,
    event = {
      "BufReadPre *.md",
      "BufNewFile *.md",
    },
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = {
        {
          name = "Obsidian",
          path = "/Users/andershakonsen/Obsidian",
        },
        {
          name = "Second Brain",
          path = "/Users/andershakonsen/satoru/",
        },

        -- {
        -- 	name = "work",
        -- 	path = "~/vaults/work",
        -- },
      },

      -- Komplett deaktivering av frontmatter endringer
      note_frontmatter_func = function(note)
        return false -- Eksplisitt false for å stoppe frontmatter oppdateringer
      end,

      -- Unngå frontmatter endringer ved nye notater
      new_notes_location = "notes_subdir",
      notes_subdir = "notes",

      -- Deaktiver automatiske operasjoner
      completion = {
        nvim_cmp = false,
      },

      -- see below for full list of options 👇
    },
    config = function(_, opts)
      require("obsidian").setup(opts)

      -- Autocmd for å forhindre frontmatter endringer
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.md",
        callback = function()
          vim.b.obsidian_disable_frontmatter = true
        end,
      })
    end,
  },

  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  --   -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  --   -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  --   ---@module 'render-markdown'
  --   ---@type render.md.UserConfig
  --   opts = {
  --     -- Vis HTML kommentarer alltid
  --     render_modes = { "n", "c", "t" }, -- normal, command, terminal mode
  --     anti_conceal = {
  --       enabled = true,
  --     },
  --   },
  -- },
}
