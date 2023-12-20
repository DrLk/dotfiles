local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f.", builtin.resume, { desc = "Resume" })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<Tab>', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, {})
vim.keymap.set('n', 'gr', builtin.lsp_references,
    { noremap = true, silent = true })
vim.keymap.set('n', 'gd', builtin.lsp_definitions,
    { noremap = true, silent = true })

require('telescope').setup {
    defaults = {
        layout_strategy = "vertical",
        layout_config = {
            height = 0.55,
            prompt_position = 'top',
        },
    }
}
