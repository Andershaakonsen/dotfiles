return {
  -- C# support
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
  -- Enhanced LSP for C#
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable csharp_ls to avoid conflicts
        csharp_ls = false,
        omnisharp = {
          cmd = { "omnisharp" },
          settings = {
            FormattingOptions = {
              OrganizeImports = true,
            },
            MsBuild = {
              LoadProjectsOnDemand = false,
            },
            RoslynExtensionsOptions = {
              EnableAnalyzersSupport = true,
              EnableImportCompletion = true,
            },
          },
        },
      },
    },
  },
  -- Ensure Mason installs OmniSharp
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "omnisharp",
        "netcoredbg", -- C# debugger
      },
    },
  },
}
