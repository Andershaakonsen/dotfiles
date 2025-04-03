return {
  "nvim-telescope/telescope.nvim",
  keys = { -- Add any custom keymaps here
    { "<leader>tx", "<cmd>Telescope<cr>", desc = "Telescope + Trouble" }, -- Example entry
  },
  config = function()
    local actions = require("telescope.actions")
    local open_with_trouble = require("trouble.sources.telescope").open

    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-x>"] = actions.delete_buffer,
            ["<leader>tx"] = open_with_trouble,
          },
          n = {
            ["<leader>tx"] = open_with_trouble,
          },
        },
        file_ignore_patterns = {
          "node_modules",
          "yarn.lock",
          ".git",
          ".sl",
          "_build",
          ".next",
        },
      },
      pickers = {
        find_files = { results_title = true },
        git_files = { results_title = false },
        git_status = { expand_dir = false },
        git_commits = {
          mappings = {
            i = {
              ["<C-M-d>"] = function()
                local action_state = require("telescope.actions.state")
                local selected_entry = action_state.get_selected_entry()
                vim.api.nvim_win_close(0, true)
                vim.cmd("stopinsert")
                vim.schedule(function()
                  vim.cmd(("DiffviewOpen %s^!"):format(selected_entry.value))
                end)
              end,
            },
          },
        },
      },
    })

    pcall(require("telescope").load_extension, "fzf")
  end,
}
