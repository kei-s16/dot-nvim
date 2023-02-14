-- LSをいい感じにインストールする
local DEFAULT_SETTINGS = {
    ensure_installed = {
      "vimls",
      "lua_ls",
      "rust_analyzer",
      "denols",
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

require("mason-lspconfig").setup_handlers {
    -- デフォルトで適用される設定
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {
          on_attach = on_attach,
        }
    end,
    -- LSごとに固有の設定
    -- ["rust_analyzer"] = function ()
    --     require("rust-tools").setup {}
    -- end
}
