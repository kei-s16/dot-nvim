vim.g.mapleader = ' '

if vim.fn.has('win64') == 1 or vim.fn.has('win32') == 1 then
    vim.opt.shellcmdflag = "-c"
    vim.opt_global.runtimepath:append(vim.env.HOME .. '/AppData/Local/nvim')
else
    vim.opt_global.runtimepath:append(vim.env.HOME .. '/.config/nvim')
end

-- dpp
require('plugins.dpp')

-- load lua files
require('settings.options')
require('settings.statusline')
if vim.fn.has('mac') == 0 then
  require('settings.tabline')
end
require('settings.keyconfig')
