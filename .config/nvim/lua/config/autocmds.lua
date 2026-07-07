-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local anki_hl_groups = {
  "@markup.heading.1.markdown", "@markup.heading.2.markdown",
  "@markup.heading.3.markdown", "@markup.heading.4.markdown",
  "@markup.heading.5.markdown", "@markup.heading.6.markdown",
  "@markup.heading.marker.markdown",
  "@label.markdown",
  "@markup.raw.block.markdown",
  "@string",
}
local anki_hl_saved = {}

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "/Users/andershakonsen/satoru/Anki/*",
  callback = function(ev)
    vim.b.autoformat = false
    vim.diagnostic.enable(false, { bufnr = ev.buf })
    local ok, rm = pcall(require, "render-markdown")
    if ok then rm.disable() end
    for _, group in ipairs(anki_hl_groups) do
      anki_hl_saved[group] = vim.api.nvim_get_hl(0, { name = group, link = true })
      vim.api.nvim_set_hl(0, group, { link = "Normal" })
    end
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "/Users/andershakonsen/satoru/Anki/*",
  callback = function(ev)
    vim.diagnostic.enable(true, { bufnr = ev.buf })
    for group, hl in pairs(anki_hl_saved) do
      vim.api.nvim_set_hl(0, group, hl)
    end
  end,
})

-- <leader>q in vault notes → open the note in the local Quartz site
require("config.quartz")
