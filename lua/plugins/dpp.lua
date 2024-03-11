local dpp_base_path = "~/.cache/dpp"
local dpp_config_path = "~/.config/nvim/ts/dpp.ts"

local denops_repo_dir = "~/.cache/dpp/repos/github.com/vim-denops/denops.vim"

local dpp_repo_dir = "~/.cache/dpp/repos/github.com/Shougo/dpp.vim"
local dpp_protocol_git_repo_dir = "~/.cache/dpp/repos/github.com/Shougo/dpp-protocol-git"
local dpp_ext_installer_repo_dir = "~/.cache/dpp/repos/github.com/Shougo/dpp-ext-installer"
local dpp_ext_toml_repo_dir = "~/.cache/dpp/repos/github.com/Shougo/dpp-ext-toml"
local dpp_ext_lazy_repo_dir = "~/.cache/dpp/repos/github.com/Shougo/dpp-ext-lazy"
local dpp_ext_local_repo_dir = "~/.cache/dpp/repos/github.com/Shougo/dpp-ext-local"

vim.opt.runtimepath:prepend(vim.fn.expand(denops_repo_dir))

vim.opt.runtimepath:prepend(vim.fn.expand(dpp_repo_dir))
vim.opt.runtimepath:prepend(vim.fn.expand(dpp_protocol_git_repo_dir))
vim.opt.runtimepath:prepend(vim.fn.expand(dpp_ext_installer_repo_dir))
vim.opt.runtimepath:prepend(vim.fn.expand(dpp_ext_toml_repo_dir))
vim.opt.runtimepath:prepend(vim.fn.expand(dpp_ext_lazy_repo_dir))
vim.opt.runtimepath:prepend(vim.fn.expand(dpp_ext_local_repo_dir))

local dpp = require("dpp")

-- vim.g["denops#debug"] = 1

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
