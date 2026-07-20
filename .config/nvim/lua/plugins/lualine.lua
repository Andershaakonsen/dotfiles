-- Override LazyVim's lualine config to remove Snacks dependency
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Remove Snacks-dependent sections from lualine
    -- This fixes: "attempt to index global 'Snacks' (a nil value)"

    -- Simple lualine config without Snacks
    return {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            path = 1, -- Show relative path
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "lazy" },
    }
  end,
}
