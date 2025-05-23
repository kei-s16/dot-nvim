-- LSをいい感じにインストールする
local DEFAULT_SETTINGS = {
    ensure_installed = {
      "vimls",
      "lua_ls",
      "rust_analyzer",
      "denols",
      "ts_ls",
      "intelephense",
      "ansiblels",
      "dockerls",
      "terraformls",
      "efm",
      "jsonls",
      "yamlls",
    },
    automatic_installation = true,
}

require("mason").setup()
require("mason-lspconfig").setup(DEFAULT_SETTINGS)

local capabilities = require("ddc_source_lsp").make_client_capabilities()

-- キーマップくらいはまとめておく
local on_attach = function(client, bufnr)
  local opts = {}
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
end

local lspconfig = require("lspconfig")

lspconfig.denols.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_markers = { "deno.json", "deno.jsonc", "deps.ts" },
  workspace_required = true,
})
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_markers = { "package.json" },
  workspace_required = true,
})

