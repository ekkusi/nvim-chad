-- NVChad sets up lua by default
local config = require "plugins.configs.lspconfig"

-- local on_attach = config.on_attach
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  config.on_attach(client, bufnr)
  vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
  end, opts)
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover()
  end, opts)
  -- Diagnostic keymaps
  vim.keymap.set("n", "Md", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
  vim.keymap.set("n", "md", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
  vim.keymap.set("n", "<leader>vws", function()
    vim.lsp.buf.workspace_symbol()
  end, opts)
  vim.keymap.set("n", "<leader>vca", function()
    vim.lsp.buf.code_action()
  end, opts)
  vim.keymap.set("n", "<leader>vrr", function()
    vim.lsp.buf.references()
  end, opts)
  vim.keymap.set("n", "<leader>vrn", function()
    vim.lsp.buf.rename()
  end, opts)
  vim.keymap.set("i", "<C-h>", function()
    vim.lsp.buf.signature_help()
  end, opts)

  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  -- nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
  nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
end
local capabilities = config.capabilities

local lspconfig = require "lspconfig"
local util = lspconfig.util

local servers = { "html", "cssls", "ts_ls", "tailwindcss", "prismals", "dockerls", "graphql", "kotlin_language_server" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    on_init = config.on_init,
  }
end

local augroup = vim.api.nvim_create_augroup("lint", {})

-- Eslint
lspconfig.eslint.setup {
  capabilities = capabilities,
  flags = { debounce_text_changes = 500 },
  -- Setup autofixing on save
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds {
        group = augroup,
        buffer = bufnr,
      }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          local function eslint_fix_and_format()
            local buf_modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
            if vim.fn.exists ":EslintFix" > 0 then
              vim.cmd "EslintFix"
            end
            -- Check if buffer was modified by the EslintFix or formatting, if so, save the changes.
            if buf_modified ~= vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
              vim.api.nvim_buf_call(bufnr, function()
                vim.cmd "silent write"
              end)
            end
          end
          vim.defer_fn(eslint_fix_and_format, 0) -- Delay to ensure ESLintFix runs in async manner
        end,
      })
    end
  end,
}

-- Go
lspconfig.gopls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
}
