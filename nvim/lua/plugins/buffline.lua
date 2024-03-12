require("bufferline").setup {
    options = {
        buffer_close_icon = '',
        mode = 'buffers',
        offsets = {
            {
                filetype = "neo-tree",
                text = "File Explorer",
                separator = true,
                padding = 1
            }
        },
        diagnostics = "nvim_lsp",
        indicator = {
            icon = '  ', -- this should be omitted if indicator style is not 'icon'
            style = 'icon'
        },
        -- separator_style = "slope"
    }
}

vim.keymap.set("n", "<leader>X", ":BufferLinePickClose<CR>", { silent = true })
-- vim.keymap.set("n", "<leader>X", ":BufferLineCloseRight<CR>", { silent = true })
vim.keymap.set("n", "<leader>s", ":BufferLineSortByTabs<CR>", { silent = true })
-- Tabs
-- vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
vim.keymap.set("n", "<s-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })

