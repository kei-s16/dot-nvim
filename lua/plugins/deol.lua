local keymap = require("utils.keymap").keymap

keymap('n', '<leader>t', ':<C-u>call deol#start({"split": "horizontal"})<CR>')

