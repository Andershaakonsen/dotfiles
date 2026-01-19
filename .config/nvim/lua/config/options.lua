-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- vim.diagnostic.config({
--   virtual_text = false, -- eller true for å aktivere
-- })

-- Line numbers (using native Neovim, not Snacks statuscolumn)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes" -- Always show signcolumn to prevent text shifting

-- Vis markdown kommentarer alltid (ikke skjul dem)
vim.opt.conceallevel = 0

-- Sørg for at markdown filer aldri skjuler innhold
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 0
    vim.opt_local.concealcursor = ""
  end,
})
