local keymap = require('utils.keymap').keymap

keymap('n', '<leader>n', ':<C-u>cnext<CR>')
keymap('n', '<leader>p', ':<C-u>cprevious<CR>')

