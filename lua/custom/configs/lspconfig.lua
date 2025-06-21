-- NVChad sets up lua by default
local config = require "plugins.configs.lspconfig"

-- local on_attach = config.on_attach
local on_attach = function(client, bufnr)
  config.on_attach(client, bufnr)
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
