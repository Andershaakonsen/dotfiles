-- GitHub Actions-støtte for workflow-filer (.github/workflows/*.yml).
-- Yaml-extraet (lazyvim.json) gir yamlls + SchemaStore (schema-validering og
-- autocomplete på on:/jobs:/steps:/uses:). Her legges to ting på toppen:
--   * gh_actions_ls - intelligens i ${{ }}-uttrykk og uses:-referanser
--   * actionlint    - Actions-spesifikk linting (shell i run:, uttrykk, runnere)

-- Egen filetype for workflow-filer, så actionlint kun kjører der (ikke på all
-- YAML). LazyVim sin lint-modul splitter "yaml.github" på "." og kjører både
-- yaml- og yaml.github-linters.
vim.filetype.add({
  pattern = {
    [".*/%.github/workflows/.*%.ya?ml"] = "yaml.github",
  },
})

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Begge serverne har "yaml" som standard-filetype og fester seg derfor
        -- ikke på "yaml.github" av seg selv - legg den til.
        yamlls = {
          filetypes = {
            "yaml",
            "yaml.docker-compose",
            "yaml.gitlab",
            "yaml.helm-values",
            "yaml.github",
          },
        },
        gh_actions_ls = {
          filetypes = { "yaml.github" },
        },
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "actionlint", "gh-actions-language-server" },
    },
  },

  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        ["yaml.github"] = { "actionlint" },
      },
    },
  },
}
