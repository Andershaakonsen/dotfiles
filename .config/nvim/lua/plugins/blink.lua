return {
  "saghen/blink.cmp",
  enabled = true, -- Re-enabled with minimal safe config
  -- opts is a *function* (not a table) on purpose: LazyVim marks
  -- `sources.default` as an `opts_extend` list, so a table override would be
  -- concatenated with LazyVim's default {lsp, path, snippets, buffer} — silently
  -- re-adding the crash-prone `snippets` source and duplicating the rest, which
  -- breaks completion in JS/JSX (friendly-snippets triggers the crash path).
  -- Assigning inside a function *replaces* the list instead of appending to it.
  opts = function(_, opts)
    -- Don't run blink inside the Telescope prompt; otherwise its completion
    -- menu hijacks <C-j>/<C-k> from Telescope's own selection movement.
    opts.enabled = function()
      return vim.bo.filetype ~= "TelescopePrompt"
    end
    opts.keymap = vim.tbl_extend("force", opts.keymap or {}, {
      preset = "default",
      -- Use Ctrl+j/k for navigation (Tab is for Supermaven)
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-space>"] = { "show", "fallback" },
    })
    opts.appearance = vim.tbl_extend("force", opts.appearance or {}, {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    })
    -- Replace (not extend) the source list: no snippets, no duplicates.
    opts.sources = opts.sources or {}
    opts.sources.default = { "lsp", "path", "buffer" }
    opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
      menu = {
        draw = {
          treesitter = { "lsp" }, -- Minimal treesitter usage
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    })
    return opts
  end,
}
