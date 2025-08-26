return {
  "tadmccorkle/markdown.nvim",
  ft = "markdown", -- or 'event = "VeryLazy"'
  opts = {
    -- configuration here or empty for defaults
    dependencies = {
      -- Sørg for at treesitter er installert
      {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
          if opts.ensure_installed ~= "all" then
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, {
              "markdown",
              "markdown_inline",
              "c_sharp", -- For C# highlighting
              "lua",
              "javascript",
              "typescript",
              -- andre språk du bruker...
            })
          end
        end,
      },
    },
  },
}
