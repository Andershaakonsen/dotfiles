-- Bare spell checking uten cmp-spell plugin
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "nb", "en" }
  end,
})

return {}