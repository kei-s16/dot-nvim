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

  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.keymap.set('n', '<C-k>', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev<CR>', opts)
  vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next<CR>', opts)
end

vim.lsp.config(
  '*',
  {
    on_attach = on_attach,
  }
)

vim.lsp.config(
  'denols',
  {
    capabilities = capabilities,
    on_attach = on_attach,
    root_markers = { "deno.json", "deno.jsonc", "deps.ts" },
    workspace_required = true,
  }
)
vim.lsp.config(
  'ts_ls',
  {
    capabilities = capabilities,
    on_attach = on_attach,
    root_markers = { "package.json" },
    workspace_required = true,
  }
)

