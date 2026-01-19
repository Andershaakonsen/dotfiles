return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  keys = {
    -- Workspace & general commands
    { "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Switch workspace" },
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
    { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian app" },
    { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch note" },
    { "<leader>of", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
    { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Search by tags" },

    -- Daily notes
    { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Today's note" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Yesterday's note" },
    { "<leader>om", "<cmd>ObsidianTomorrow<cr>", desc = "Tomorrow's note" },
    { "<leader>oD", "<cmd>ObsidianDailies<cr>", desc = "List daily notes" },

    -- Current note commands
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks" },
    { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Show all links" },
    { "<leader>oT", "<cmd>ObsidianTOC<cr>", desc = "Table of contents" },
    { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename note" },
    { "<leader>oc", "<cmd>ObsidianToggleCheckbox<cr>", desc = "Toggle checkbox" },
    { "<leader>oF", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link under cursor" },

    -- Templates & images
    { "<leader>oI", "<cmd>ObsidianTemplate<cr>", desc = "Insert template" },
    { "<leader>oi", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image" },
    { "<leader>ont", "<cmd>ObsidianNewFromTemplate<cr>", desc = "New note from template" },

    -- Visual mode commands
    { "<leader>oe", "<cmd>ObsidianExtractNote<cr>", mode = "v", desc = "Extract selection to new note" },
    { "<leader>oL", "<cmd>ObsidianLink<cr>", mode = "v", desc = "Link selection to note" },
    { "<leader>oln", "<cmd>ObsidianLinkNew<cr>", mode = "v", desc = "Link selection to new note" },
  },
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/vaults/personal",
      },
      {
        name = "Second Brain",
        path = "/Users/andershakonsen/satoru",
      },
    },

    -- Exclude Anki folder from searches
    picker = {
      name = "telescope.nvim",
      mappings = {
        new = "<C-x>",
      },
    },

    -- see below for full list of options 👇
  },
}
