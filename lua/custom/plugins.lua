local plugins = {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      return require "custom.configs.formatter"
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      ensure_installed = {
        "typescript-language-server",
        "tailwindcss-language-server",
        "graphql-language-service-cli",
        "prisma-language-server",
        "dockerfile-language-server",
        "eslint-lsp",
        "prettierd",
        "lua-language-server",
        "html-lsp",
        "css-lsp",
        "gopls",
        "kotlin-language-server",
        "prettierd",
        "stylua",
        "isort",
        "black",
        "gofumpt",
        "goimports-reviser",
        "ktlint",
        "eslint_d",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "custom.configs.lspconfig"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      return require "custom.configs.treesitter"
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require "custom.configs.LuaSnip"
    end,
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
    config = function()
      require "custom.configs.vim-fugitive"
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "custom.configs.nvimtree"
    end,
  },
  "nvim-telescope/telescope-ui-select.nvim",
  {
    "nvim-telescope/telescope.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable "make" == 1
      end,
    },
  },
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    -- cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local c = require("vscode.colors").get_colors()
      require("vscode").setup {
        group_overrides = {
          IndentBlanklineChar = { fg = c.vscContext },
          IndentBlanklineContextChar = { fg = c.vscContextCurrent },
        },
      }
      require("vscode").load()
    end,
  },
  {
    "Hiphish/rainbow-delimiters.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("rainbow-delimiters.setup").setup {
        query = {
          tsx = "rainbow-parens",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },
  "JoosepAlviste/nvim-ts-context-commentstring",
  {
    "numToStr/Comment.nvim",
    opts = function()
      return require "custom.configs.comment"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "custom.configs.nvim-spectre"
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "itchyny/vim-qfedit",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "ThePrimeagen/harpoon",
    event = "User FilePost",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require "custom.configs.harpoon"
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
    },
    config = function()
      require "custom.configs.codecompanion"
    end,
  },
  {
    "ravitemer/mcphub.nvim",
    event = { "BufReadPre", "BufNewFile" },
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup()
    end,
  },
  {
    "milanglacier/minuet-ai.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "custom.configs.minuet-ai"
    end,
  },
}
return plugins
