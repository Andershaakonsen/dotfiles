require("user.options")
require("user.lazy")
require("user.keymaps")
require("user.highlight_yank")
require("user.toggle_diagnostics")
require("user.markdown_copilot")
require("user.markdown_settings")

-- vim.cmd([[
--   autocmd FileType markdown lua require('user.markdown_copilot')
-- ]])

vim.g.python3_host_prog = "/Users/andershakonsen/.neovim-venv/bin/python"
vim.cmd.colorscheme("tokyonight")
