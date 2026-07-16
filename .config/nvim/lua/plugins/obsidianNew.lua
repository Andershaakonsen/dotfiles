return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  keys = {
    -- Workspace & general commands
    { "<leader>ow", "<cmd>Obsidian workspace<cr>", desc = "Switch workspace" },
    { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
    { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Open in Obsidian app" },
    { "<leader>os", "<cmd>Obsidian quick_switch<cr>", desc = "Quick switch note" },
    { "<leader>of", "<cmd>Obsidian search<cr>", desc = "Search notes" },
    { "<leader>ot", "<cmd>Obsidian tags<cr>", desc = "Search by tags" },

    -- Daily notes
    { "<leader>od", "<cmd>Obsidian today<cr>", desc = "Today's note" },
    { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Yesterday's note" },
    { "<leader>om", "<cmd>Obsidian tomorrow<cr>", desc = "Tomorrow's note" },
    { "<leader>oD", "<cmd>Obsidian dailies<cr>", desc = "List daily notes" },

    -- Current note commands
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Show backlinks" },
    { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Show all links" },
    { "<leader>oT", "<cmd>Obsidian toc<cr>", desc = "Table of contents" },
    { "<leader>or", "<cmd>Obsidian rename<cr>", desc = "Rename note" },
    { "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle checkbox" },
    { "<leader>oF", "<cmd>Obsidian follow_link<cr>", desc = "Follow link under cursor" },

    -- Templates & images
    { "<leader>oI", "<cmd>Obsidian template<cr>", desc = "Insert template" },
    { "<leader>oi", "<cmd>Obsidian paste_img<cr>", desc = "Paste image" },
    { "<leader>ont", "<cmd>Obsidian new_from_template<cr>", desc = "New note from template" },

    -- Visual mode commands
    { "<leader>oe", "<cmd>Obsidian extract_note<cr>", mode = "v", desc = "Extract selection to new note" },
    { "<leader>oL", "<cmd>Obsidian link<cr>", mode = "v", desc = "Link selection to note" },
    { "<leader>oln", "<cmd>Obsidian link_new<cr>", mode = "v", desc = "Link selection to new note" },
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
    legacy_commands = false,
    workspaces = {
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
