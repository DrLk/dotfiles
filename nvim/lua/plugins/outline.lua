require('outline').setup()

vim.keymap.set("n", "<S-c>", ":BSOpen<CR>", { silent = true, desc = "Toggle Buffer tab " })
