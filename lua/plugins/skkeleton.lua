local keymap = require('utils.keymap').keymap

vim.fn['skkeleton#azik#add_table']()
vim.fn['skkeleton#azik#set_keyconfig']()

vim.fn['skkeleton#config']{
  globalJisyo = '~/.skk/SKK-JISYO.L',
  userJisyo = '~/.skk/USER.L',
  kanaTable = 'azik'
}

keymap('i', '<C-j>', '<Plug>(skkeleton-enable)')
keymap('c', '<C-j>', '<Plug>(skkeleton-enable)')
keymap('i', '<C-l>', '<Plug>(skkeleton-disable)')
keymap('c', '<C-l>', '<Plug>(skkeleton-disable)')
