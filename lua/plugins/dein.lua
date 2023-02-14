if vim.fn.has('win64') == 1 or vim.fn.has('win32') == 1 then
    vim.api.nvim_set_var('python3_host_prog', vim.fn.expand('~/scoop/apps/python/current/python.exe'))
    vim.api.nvim_set_var('rc_dir', vim.fn.expand("~/AppData/Local/nvim"))
    vim.api.nvim_set_var('toml_dir', vim.api.nvim_get_var('rc_dir') .. '/toml')
else
    vim.api.nvim_set_var('python3_host_prog', vim.fn.expand('~/.asdf/shims/python'))
    vim.api.nvim_set_var('rc_dir', vim.fn.expand("~/.config/nvim"))
    vim.api.nvim_set_var('toml_dir', vim.api.nvim_get_var('rc_dir') .. '/toml')
end

if vim.opt.compatible:get() == true then
    -- Be iMproved
    vim.opt.compatible = false
end

local dein_dir = vim.env.HOME .. '/.cache/dein'
local dein_repo_dir = dein_dir .. '/repos/github.com/Shougo/dein.vim'

vim.api.nvim_set_var('dein#install_process_timeout', 300)

if not string.match(table.concat(vim.opt_global.runtimepath:get()), 'dein.vim') then
    if vim.fn.isdirectory(dein_repo_dir) then
        os.execute('git clone https://github.com/Shougo/dein.vim ' .. dein_repo_dir)
    end

    if vim.fn.has('win64') == 1 or vim.fn.has('win32') == 1 then
        vim.opt_global.runtimepath:append(dein_repo_dir)
    else
        vim.opt_global.runtimepath:append(vim.fn.fnamemodify(dein_repo_dir, ':p'))
    end
end

if vim.fn['dein#load_state'](dein_dir) == 1 then
    vim.fn['dein#begin'](dein_dir)

    -- toml
    vim.api.nvim_set_var('dein_toml', vim.api.nvim_get_var('toml_dir') .. '/dein.toml')
    vim.api.nvim_set_var('ddc_toml', vim.api.nvim_get_var('toml_dir') .. '/ddc.toml')
    vim.api.nvim_set_var('ddu_toml', vim.api.nvim_get_var('toml_dir') .. '/ddu.toml')
    vim.api.nvim_set_var('git_toml', vim.api.nvim_get_var('toml_dir') .. '/git.toml')
    vim.api.nvim_set_var('lsp_toml', vim.api.nvim_get_var('toml_dir') .. '/lsp.toml')

    -- load toml
    vim.fn['dein#load_toml'](vim.api.nvim_get_var('dein_toml'), {lazy = 0})
    vim.fn['dein#load_toml'](vim.api.nvim_get_var('ddc_toml'), {lazy = 1})
    vim.fn['dein#load_toml'](vim.api.nvim_get_var('ddu_toml'), {lazy = 1})
    vim.fn['dein#load_toml'](vim.api.nvim_get_var('git_toml'), {lazy = 1})
    vim.fn['dein#load_toml'](vim.api.nvim_get_var('lsp_toml'), {lazy = 1})

    vim.fn['dein#end']()
    vim.fn['dein#save_state']()
end

-- required
vim.cmd('filetype plugin indent on')
vim.cmd('syntax enable')

if not vim.fn['dein#check_install']() == 1 then
    vim.fn['dein#install']()
end

