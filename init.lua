vim.g.mapleader = ' '

if vim.fn.has('win64') == 1 or vim.fn.has('win32') == 1 then
    vim.opt.shellcmdflag = "-c"
    vim.opt_global.runtimepath:append(vim.env.HOME .. '/AppData/Local/nvim')
else
    vim.opt_global.runtimepath:append(vim.env.HOME .. '/.config/nvim')
end

-- dein
require('plugins.dein')

-- load lua files
require('settings.options')
require('settings.statusline')
