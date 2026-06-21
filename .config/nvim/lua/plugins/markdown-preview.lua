-- https://github.com/iamcco/markdown-preview.nvim
-- Live markdown preview in the browser. Renders the current buffer and
-- updates as you type. Commands: :MarkdownPreview, :MarkdownPreviewStop,
-- :MarkdownPreviewToggle.
return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    -- Build without yarn (node-only) so it doesn't depend on yarn being on PATH.
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview (toggle)" },
    },
    init = function()
      -- Don't auto-open the browser on buffer enter; toggle explicitly.
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
    end,
  },
}
