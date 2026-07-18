-- GitHub Actions-støtte for workflow-filer (.github/workflows/*.yml).
-- Yaml-extraet (lazyvim.json) gir yamlls + SchemaStore (schema-validering og
-- autocomplete på on:/jobs:/steps:/uses:). Her legges to ting på toppen:
--   * gh_actions_ls - intelligens i ${{ }}-uttrykk og uses:-referanser
--   * actionlint    - Actions-spesifikk linting (shell i run:, uttrykk, runnere)

-- Egen filetype for workflow-filer, så actionlint kun kjører der (ikke på all
-- YAML). LazyVim sin lint-modul splitter "yaml.github" på "." og kjører både
-- yaml- og yaml.github-linters.
--
-- I tillegg: mengdetrening-drillene i gh200-actions-practice ligger i drills/
-- (utenfor .github/workflows/, så GitHub ikke kjører dem), men skal ha samme
-- Actions-verktøy lokalt. Mønsteret er scopet til det repoet så det ikke slår
-- inn på tilfeldige drills/-mapper i andre prosjekter.
vim.filetype.add({
  pattern = {
    [".*/%.github/workflows/.*%.ya?ml"] = "yaml.github",
    [".*/gh200%-actions%-practice/drills/.*%.ya?ml"] = "yaml.github",
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
          -- Den innebygde root_dir krever at mappa SLUTTER på .github/workflows.
          -- Løsne til å matche hvis stien INNEHOLDER .github|.forgejo|.gitea/
          -- workflows, PLUSS gh200-actions-practice/drills (mengdetrening som
          -- bevisst ligger utenfor .github/workflows/), slik at de også får LSP.
          root_dir = function(bufnr, on_dir)
            local parent = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
            if
              parent:find("/%.github/workflows")
              or parent:find("/%.forgejo/workflows")
              or parent:find("/%.gitea/workflows")
              or parent:find("/gh200%-actions%-practice/drills")
            then
              on_dir(parent)
            end
          end,
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
