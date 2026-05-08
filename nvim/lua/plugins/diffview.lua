local map = vim.keymap.set

map('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'File history' })
map('n', '<leader>gH', '<cmd>DiffviewFileHistory<cr>', { desc = 'Repo history' })
map('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Diff working tree' })
map('n', '<leader>gq', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' })

require('diffview').setup {
    view = {
        file_history = {
            layout = 'diff2_horizontal',
        },
    },
    file_panel = {
        win_config = {
            width = 35,
        },
    },
    hooks = {
        diff_buf_read = function(bufnr)
            vim.opt_local.wrap = false
        end,
    },
}
