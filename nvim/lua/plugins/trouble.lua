local trouble = require("trouble")
trouble.setup({
        group = true, -- group results by file
        skip_groups = true,
    action_keys = {
        previous = "<leader>k", -- previous item
        next = "<leader>j",     -- next item
    },
    }
)
vim.keymap.set("n", "<leader>xx", function() trouble.close() end, { desc = "toggle" })
vim.keymap.set("n", "<leader>xw", function() trouble.close() trouble.open("workspace_diagnostics") end, { desc = "workspace" })
vim.keymap.set("n", "<leader>xd", function() trouble.open("document_diagnostics") end, { desc = "document" })
vim.keymap.set("n", "<leader>xq", function() trouble.open("quickfix") end, { desc = "quickfix" })
vim.keymap.set("n", "<leader>xl", function() trouble.open("loclist") end, { desc = "loclist" })
vim.keymap.set("n", "gr", function() trouble.open("lsp_references") end, { desc = "lsp_references" })
vim.keymap.set("n", "gi", function() trouble.open("lsp_implementations") end, { desc = "lsp_implementations" })
local next_skip_groups = function()
    trouble.next({ skip_groups = true });
end

local previous_skip_groups = function()
    trouble.previous({ skip_groups = true });
end

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "Trouble" },
    callback = function(args)
        vim.api.nvim_buf_set_keymap(
            args.buf,
            'n',
            'j',
            "",
            {
                callback = next_skip_groups
            })
        vim.api.nvim_buf_set_keymap(
            args.buf,
            'n',
            'k',
            "",
            {
                callback = previous_skip_groups
            })
    end,
})

