local utils = require "custom.utils"

local M = {}

M.general = {
  n = {
    -- movement
    ["<C-d>"] = { "<C-d>zz" },

    -- windows
    ["<C-q>"] = { "<C-w>q", "Close windows" },

    -- edit all hovered word
    ["<leader>s"] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]] },

    -- Close floating windows and remove search
    ["<Esc>"] = {
      function()
        utils.OnEscape()
      end,
      "Close floating windows",
    },

    -- Code actions
    ["<leader>."] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code actions" },

    -- Reload config
    ["<leader>R"] = {
      function()
        utils.ReloadConfig()
      end,
      "Reload config",
    },
  },
  v = {
    -- move selection up/down
    ["K"] = { ":m '<-2<CR>gv=gv" },
    ["J"] = { ":m '>+1<CR>gv=gv" },

    --edit all selected word
    ["<leader>s"] = { [["hy:%s/<C-r>h//gI<Left><Left><Left>]] },
  },
}

M.comment = {
  -- toggle comment in both modes
  n = {
    ["<leader>c"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
    },
  },

  v = {
    ["<leader>c"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "Toggle comment",
    },
  },
}

M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    ["<leader>t"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },

    -- focus
    ["<leader>T"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },

    -- Unmap Ctrl + k
    -- ["<C-I>"] = { "<cmd> NvimTreeInfo <CR>", "NvimTreeInfo" },
    ["<C-k>"] = { "<C-w>k", "Window up" },
  },
}

return M
