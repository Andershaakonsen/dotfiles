return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = true,
  enabled = false,
  version = false, -- Never set this value to "*"! Never!
  opts = {
    -- add any opts here
    -- for example
    provider = "copilot",
    -- set to claude s
    providers = {

      copilot = {
        -- model gpt
        --Working:
        model = "claude-3.5-sonnet",
        -- model = "Calude Sonnet 4",
        -- model = "gpt-4",
        -- Not working:
        -- model = "claude-3-7",
        --       model = "claude-3-7-sonnet-20240229", -- Claude 3.7 Sonnet model
        -- model = "claude-3-7-sonnet",
        -- model = "claude/claude-3-7-sonnet-20250219",
        -- model = "claude-3-7-sonnet-20250219",
        -- model = "claude-3-7-sonnet-20250219", -- Latest Claude 3.7 Sonnet model
        -- model = "claude-3-7-sonnet-20240229", -- Correct format for Claude 3.7 Sonnet
        -- model = "anthropic/claude-3-7-sonnet", -- Try this format
        -- model = "gpt-4-1",
        -- model = "claude-3-7-sonnet", -- Without date suffix
        -- model = "gemini-2-5-pro", -- Try this format for Gemini 2.5 Pro
      },
    },
    -- openai = {
    --   endpoint = "https://api.openai.com/v1",
    --   model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
    --   timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
    --   temperature = 0,
    --   max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
    --   --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
    -- },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-mini/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        mappings = {
          ask = "<leader>at",
        },
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
