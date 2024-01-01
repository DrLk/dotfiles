local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f.", function()
    builtin.resume({ initial_mode = "normal" })
end, { noremap = true, silent = true, desc = "Resume" })
vim.keymap.set('n', '<leader>ff', function()
    builtin.find_files({ initial_mode = "insert" })
end, { noremap = true, silent = true, desc = "Find files" })
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', function()
    builtin.buffers({ initial_mode = "normal" })
end, { noremap = true, silent = true, desc = "Buffers" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})

vim.keymap.set('n', '<leader>gs', function()
    builtin.git_status({ initial_mode = "normal" })
end, { noremap = true, silent = true, desc = "Git status" })

vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, {})

-- vim.keymap.set('n', 'gr', function()
--     builtin.lsp_references({ initial_mode = "normal" })
-- end, { noremap = true, silent = true, desc = "References" })

vim.keymap.set('n', 'gd', function()
    builtin.lsp_definitions({ initial_mode = "normal" })
end, { noremap = true, silent = true, desc = "Definitions" })


local telescope = require("telescope")
local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")
telescope.setup {
    defaults = {
        layout_strategy = "vertical",
        layout_config = {
            height = 0.55,
            prompt_position = 'top',
        },
        mappings = {
            n = {
                ["q"] = actions.close,
                ["<c-t>"] = trouble.open_with_trouble,
            },
            i = { ["<c-t>"] = trouble.open_with_trouble },
        }
    }
}
