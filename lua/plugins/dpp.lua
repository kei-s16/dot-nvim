local dpp_base_path = "~/.cache/dpp"
local dpp_config_path = "~/.config/nvim/ts/dpp.ts"

local required_plugin_dir = "~/.cache/dpp/repos/github.com/"
local required_plugins = {
  "vim-denops/denops.vim",
  "Shougo/dpp.vim",
  "Shougo/dpp-protocol-git",
  "Shougo/dpp-ext-installer",
  "Shougo/dpp-ext-toml",
  "Shougo/dpp-ext-lazy",
  "Shougo/dpp-ext-local",
}

local function load_plugins(plugins)
  for _, plugin in ipairs(plugins) do
    vim.opt.runtimepath:prepend(vim.fn.expand(required_plugin_dir .. plugin))
  end
end

load_plugins(required_plugins)

local dpp = require("dpp")

if dpp.load_state(dpp_base_path) then
  vim.api.nvim_create_autocmd("User", {
    pattern = "DenopsReady",
    callback = function()
      vim.notify("dpp load_state() is failed")
      dpp.make_state(dpp_base_path, dpp_config_path)
    end,
  })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "Dpp:makeStatePost",
  callback = function()
    vim.notify("dpp make_state() is done")
  end,
})

vim.cmd("filetype indent plugin on")
vim.cmd("syntax on")
