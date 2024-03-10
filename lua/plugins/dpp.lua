local dpp_base_path = "~/.cache/dpp"
local dpp_config_path = "~/.config/nvim/ts/dpp.ts"

local dpp_repo_dir = "~/.cache/dpp/repos/github.com/Shougo/dpp.vim"
local denops_repo_dir = "~/.cache/dpp/repos/github.com/vim-denops/denops.vim"
local dpp_ext_installer_repo_dir = "~/.cache/dpp/repos/github.com/Shougo/dpp-ext-installer"

vim.opt.runtimepath:prepend(dpp_repo_dir)

local dpp = require("dpp")

if dpp.load_state(dpp_base_path) then
vim.opt.runtimepath:prepend(denops_repo_dir)
  vim.opt.runtimepath:prepend(dpp_ext_installer_repo_dir)

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

dpp.load_state(dpp_config_path)

