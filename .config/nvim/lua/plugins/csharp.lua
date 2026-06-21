-- C# tooling, Roslyn-based (omnisharp fully removed).
-- The LazyVim `lang.dotnet` extra (omnisharp + omnisharp-extended) has been
-- dropped from lazyvim.json, so everything C# lives here. Debugging is set up
-- separately in dap.lua (coreclr/netcoredbg).
return {
  -- C# treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "c_sharp",
        "json",
        "yaml",
        "dockerfile",
      },
    },
  },
  -- Roslyn LSP (same engine as VS Code C# Dev Kit, supports .slnx)
  {
    "seblj/roslyn.nvim",
    ft = "cs",
    opts = {},
  },
  -- Format C# with csharpier
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
    },
  },
  -- Mason: C# formatter + debugger
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "csharpier",
        "netcoredbg",
      },
    },
  },
}
