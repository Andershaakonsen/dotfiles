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

-- Opening nvim with no file args anywhere in the dotfiles tree → open the root README
local function open_dotfiles_readme()
  -- only when launched without any file arguments
  if vim.fn.argc() ~= 0 then
    return
  end

  -- don't clobber a buffer that already has content (e.g. piped stdin)
  local buf = vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_get_name(buf) ~= "" or vim.bo[buf].modified then
    return
  end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  if #lines > 1 or (lines[1] or "") ~= "" then
    return
  end

  local dotfiles = vim.fn.expand("~/dotfiles")
  local cwd = vim.fn.getcwd()
  if cwd ~= dotfiles and not vim.startswith(cwd, dotfiles .. "/") then
    return
  end

  local readme = dotfiles .. "/README.md"
  if vim.fn.filereadable(readme) == 1 then
    -- Force-load nvim-treesitter *before* opening the buffer. It's lazy-loaded
    -- on BufReadPost, so opening the README here would fire FileType before its
    -- highlighter attaches — leaving the buffer unhighlighted until a manual
    -- :e re-fired FileType. Loading it first registers the FileType handler so
    -- highlighting attaches on this first load.
    pcall(function()
      require("lazy").load({ plugins = { "nvim-treesitter" } })
    end)
    vim.cmd.edit(readme)
    -- Belt-and-suspenders: ensure the filetype is set (drives ftplugins + the
    -- treesitter FileType handler) and attach the treesitter highlighter with
    -- an explicit lang, in case the FileType detection/handler lost the startup
    -- race. Native API, no-ops if already active.
    vim.schedule(function()
      local b = vim.api.nvim_get_current_buf()
      if vim.bo[b].filetype ~= "markdown" then
        vim.bo[b].filetype = "markdown"
      end
      pcall(vim.treesitter.start, b, "markdown")
    end)
  end
end

-- LazyVim loads this file on VeryLazy; with no file args that fires *after*
-- VimEnter, so run immediately if we've already entered, else wait for VimEnter.
if vim.v.vim_did_enter == 1 then
  open_dotfiles_readme()
else
  vim.api.nvim_create_autocmd("VimEnter", { callback = open_dotfiles_readme })
end

-- <leader>q in vault notes → open the note in the local Quartz site
require("config.quartz")
