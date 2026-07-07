return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local tokyonight = require("tokyonight")

      -- Build the tokyonight setup opts. `transparent` is parameterized so the
      -- light/dark toggle can turn transparency OFF in light mode (otherwise the
      -- terminal's dark background shows through and "light mode" looks broken)
      -- and back ON in dark mode, which is the default transparent look.
      -- Dark styles, from lightest to darkest. <leader>us cycles through these.
      local dark_styles = { "storm", "moon", "night" }
      local dark_idx = 3 -- start on `night`

      local function opts(transparent, style)
        return {
          style = style, -- one of storm/moon/night; light_style is used when bg=light
          light_style = "day", -- The theme is used when the background is set to light
          transparent = transparent, -- Enable this to disable setting the background color
          terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)

          styles = {
            -- Style to be applied to different syntax groups
            -- Value is any valid attr-list value for `:help nvim_set_hl`
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            -- Background styles. Can be "dark", "transparent" or "normal"
            sidebars = transparent and "transparent" or "normal", -- style for sidebars, see below
            floats = transparent and "transparent" or "normal", -- style for floating windows
            tabline = transparent and "transparent" or "normal",
          },
          sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
          day_brightness = 0.9, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
          hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
          dim_inactive = false, -- dims inactive windows
          lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
          --- You can override specific color groups to use other groups or a hex color
          --- function will be called with a ColorScheme table
          ---@param colors ColorScheme
          on_colors = function(colors) end,

          --- You can override specific highlights to use other groups or a hex color
          --- function will be called with a Highlights and ColorScheme table
          ---@param highlights Highlights
          ---@param colors ColorScheme
          on_highlights = function(highlights, colors) end,
        }
      end

      -- Apply a colorscheme for a given background ("dark"/"light").
      -- Dark   -> tokyonight, transparent (default look), chosen dark variant.
      -- Light  -> catppuccin-latte, opaque. tokyonight's `day` style is very
      --           low-contrast/washed out, so latte is used for a readable light
      --           theme instead.
      local function apply(bg)
        vim.o.background = bg
        if bg == "light" then
          local ok, catppuccin = pcall(require, "catppuccin")
          if ok then
            catppuccin.setup({ flavour = "latte", transparent_background = false })
          end
          vim.cmd.colorscheme("catppuccin-latte")
        else
          tokyonight.setup(opts(true, dark_styles[dark_idx]))
          vim.cmd.colorscheme("tokyonight")
        end
      end

      apply("dark")

      -- LazyVim binds <leader>ub to its own background toggle on VeryLazy, which
      -- fires after this config runs. Register ours on VeryLazy too so it wins
      -- and goes through apply() (which also flips transparency).
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          vim.keymap.set("n", "<leader>ub", function()
            apply(vim.o.background == "dark" and "light" or "dark")
            vim.notify("Background: " .. vim.o.background, vim.log.levels.INFO)
          end, { desc = "Toggle light/dark background" })

          -- Cycle the dark variant (storm -> moon -> night). Switches to dark
          -- mode first if currently light, so the change is visible.
          vim.keymap.set("n", "<leader>us", function()
            dark_idx = dark_idx % #dark_styles + 1
            apply("dark")
            vim.notify("Dark style: " .. dark_styles[dark_idx], vim.log.levels.INFO)
          end, { desc = "Cycle tokyonight dark style" })
        end,
      })
    end,
  },
}
