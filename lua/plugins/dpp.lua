local config_base_path = ""

if vim.fn.has('win64') == 1 or vim.fn.has('win32') == 1 then
  config_base_path = vim.env.HOME .. '/AppData/Local'
else
  config_base_path = vim.env.HOME .. '/.config'
end

local dpp_base_path = "~/.cache/dpp"
local dpp_config_path = config_base_path .. "/nvim/ts/dpp.ts"

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

vim.api.nvim_create_user_command(
  "DppUpdateState",
  function()
      dpp.make_state(dpp_base_path, dpp_config_path)
  end,
  { nargs = 0 }
)

vim.api.nvim_create_user_command(
  "DppInstallPlugin",
  function()
      dpp.async_ext_action("installer", "install")
  end,
  { nargs = 0 }
)

vim.api.nvim_create_user_command(
  "DppUpdatePlugin",
  function()
      dpp.async_ext_action("installer", "update")
  end,
  { nargs = 0 }
)

