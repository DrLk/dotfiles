local lspsaga = require('lspsaga')


lspsaga.setup({})

vim.keymap.set("n", "<Leader>lr", "<cmd>Lspsaga rename<CR>")
