return {
  -- DAP (Debug Adapter Protocol) setup
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI for DAP
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dap = require("dap")
          local dapui = require("dapui")

          dapui.setup()

          -- Auto open/close DAP UI
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      -- Virtual text for debugging
      -- {
      --   "theHamsta/nvim-dap-virtual-text",
      --   config = function()
      --     require("nvim-dap-virtual-text").setup()
      --   end,
      -- },
    },
    config = function()
      local dap = require("dap")

      -- .NET Core debugger configuration
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.expand("~/.local/bin/netcoredbg/netcoredbg"), -- Path to netcoredbg
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch - .NET Web API",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          env = {
            ASPNETCORE_ENVIRONMENT = "Development",
            ASPNETCORE_URLS = "https://localhost:5001;http://localhost:5000",
          },
          args = {},
          console = "integratedTerminal",
          stopAtEntry = false,
        },
        {
          type = "coreclr",
          name = "Launch - Auto-find DLL",
          request = "launch",
          program = function()
            -- Auto-find the main DLL in bin/Debug
            local cwd = vim.fn.getcwd()
            local pattern = cwd .. "/bin/Debug/net*/PAMS-Backend.dll" -- Replace with your project name
            local files = vim.fn.glob(pattern, false, true)
            if #files > 0 then
              return files[1]
            else
              return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
            end
          end,
          cwd = "${workspaceFolder}",
          env = {
            ASPNETCORE_ENVIRONMENT = "Development",
            ASPNETCORE_URLS = "https://localhost:5001;http://localhost:5000",
          },
          args = {},
          console = "integratedTerminal",
          stopAtEntry = false,
        },
        {
          type = "coreclr",
          name = "Attach - .NET Core",
          request = "attach",
          processId = function()
            return require("dap.utils").pick_process()
          end,
        },
      }

      -- Debug keymaps with error handling
      vim.keymap.set("n", "<leader>db", function()
        print("Setting breakpoint...")
        dap.toggle_breakpoint()
      end, { desc = "Toggle Breakpoint" })

      vim.keymap.set("n", "<leader>dc", function()
        print("Starting debugger...")
        dap.continue()
      end, { desc = "Continue" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })

      -- DAP UI keymaps
      vim.keymap.set("n", "<leader>du", function()
        require("dapui").toggle()
      end, { desc = "Toggle Debug UI" })

      vim.keymap.set("n", "<leader>de", function()
        require("dapui").eval()
      end, { desc = "Evaluate Expression" })
    end,
  },
}

