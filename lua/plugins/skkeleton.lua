local keymap = require('utils.keymap').keymap

if vim.fn.has('mac') == 1 then
  vim.fn['skkeleton#azik#add_table']('jis')
else
  vim.fn['skkeleton#azik#add_table']('us')
end

vim.fn['skkeleton#config']{
  globalDictionaries = {
    '~/.skk/SKK-JISYO.L',
    '~/.skk/SKK-JISYO.kei-s16',
    '~/.skk/SKK-JISYO.mtg',
  },
  userJisyo = '~/.skk/USER.L',
  kanaTable = 'azik'
}

keymap('i', '<C-j>', '<Plug>(skkeleton-enable)')
keymap('c', '<C-j>', '<Plug>(skkeleton-enable)')
keymap('i', '<C-l>', '<Plug>(skkeleton-disable)')
keymap('c', '<C-l>', '<Plug>(skkeleton-disable)')
