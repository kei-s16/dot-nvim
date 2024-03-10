local dppBase = "~/.cache/dpp"
local dppConfig = "~/.config/nvim/ts/dpp.ts"

local dppSrc = "~/.cache/dpp/repos/github.com/Shougo/dpp.vim"
local denopsSrc = "~/.cache/dpp/repos/github.com/vim-denops/denops.vim"
local denopsInstaller = "~/.cache/dpp/repos/github.com/Shougo/dpp-ext-installer"

vim.opt.runtimepath:prepend(dppSrc)

local dpp = require("dpp")

if dpp.load_state(dppBase) then
vim.opt.runtimepath:prepend(denopsSrc)
  vim.opt.runtimepath:prepend(denopsInstaller)

  vim.api.nvim_create_autocmd("User", {
    pattern = "DenopsReady",
    callback = function()
      vim.notify("dpp load_state() is failed")
      dpp.make_state(dppBase, dppConfig)
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

dpp.load_state(dppConfig)
