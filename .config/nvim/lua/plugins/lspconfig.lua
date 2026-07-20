return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      -- (a) Run ONLY vtsls for JS/TS. typescript-language-server is also
      -- installed in Mason and was auto-attaching alongside vtsls — two TS
      -- servers on one buffer caused the didClose "_isInitialized" errors
      -- and the SIGTERM restart churn in the LSP log.
      ts_ls = { enabled = false },

      -- (b) These get auto-enabled by mason-lspconfig but attach to JS/TS/JSX
      -- buffers as pure noise (graphql-config errors, emmet). Turn them off.
      graphql = { enabled = false },
      emmet_ls = { enabled = false },
    },
  },
}
