-- fff.nvim — fast fuzzy file finder (Rust-backed, frecency ranking).
-- https://github.com/dmtrKovalenko/fff.nvim
--
-- Now owns <leader>ff (find files) and <leader>fs (live grep), replacing the
-- telescope binds (removed from snacks.lua). Telescope is no longer key-bound.
--
-- CRASH-SAFETY: preview is disabled on purpose. Floating *previewers* are the
-- pattern behind disabling telescope's previewer and the Snacks picker (see
-- CLAUDE.md). A picker float WITHOUT preview is the same shape as the telescope
-- setup that already runs fine here. If it still crashes, remove this file.
--
-- Layout mirrors telescope: prompt at top, no preview. <C-j>/<C-k> added to the
-- nav keys to match telescope/blink muscle memory.
--
-- Install pulls a prebuilt binary (falls back to `cargo` only if needed), so a
-- Rust toolchain is not strictly required. Run :Lazy sync to install.
return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  opts = {
    preview = { enabled = false },
    layout = {
      prompt_position = "top", -- match telescope (sorting_strategy = ascending)
    },
    keymaps = {
      move_up = { "<Up>", "<C-p>", "<C-k>" },
      move_down = { "<Down>", "<C-n>", "<C-j>" },
    },
  },
  keys = {
    { "<leader>ff", function() require("fff").find_files() end, desc = "Find Files (fff)" },
    { "<leader>fs", function() require("fff").live_grep() end, desc = "Find String (fff)" },
    {
      "<leader>Fw",
      function() require("fff").live_grep_under_cursor() end,
      mode = { "n", "x" },
      desc = "fff: grep word/selection",
    },
  },
}
