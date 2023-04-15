-- LSをいい感じにインストールする
local DEFAULT_SETTINGS = {
    ensure_installed = {
      "vimls",
      "lua_ls",
      "rust_analyzer",
      "denols",
      "tsserver",
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

local lspconfig = require("lspconfig")

require("mason-lspconfig").setup_handlers {
  ["denols"] = function ()
    lspconfig.denols.setup {
      root_dir = lspconfig.util.root_pattern("deno.json")
    }
  end,
  ["tsserver"] = function ()
    lspconfig.tsserver.setup {
      root_dir = lspconfig.util.root_pattern('package.json', 'tsconfig.json')
    }
  end,
  function (server_name) -- 明示的に指定してないやつ一括で
    lspconfig[server_name].setup {
      on_attach = on_attach,
    }
  end
}
