-- https://github.com/3rd/image.nvim
return {
  {
    "3rd/image.nvim",
    enabled = false, -- Temporarily disabled to test Telescope crash
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          only_render_image_at_cursor_mode = "popup", -- eller "inline"
        },
        neorg = {
          enabled = true,
          filetypes = { "norg" },
        },
      },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        dir_path = "assets/imgs", -- relative til current file eller
        -- dir_path = function() return "assets" end, -- eller funksjon
      },
    },
    keys = {
      -- suggested keymap
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
}
