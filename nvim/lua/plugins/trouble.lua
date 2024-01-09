local trouble = require("trouble")
trouble.setup({
        group = true, -- group results by file
        skip_groups = true,
    }
)
vim.keymap.set("n", "<leader>xx", function() trouble.toggle() end, { desc = "toggle" })
vim.keymap.set("n", "<leader>xw", function() trouble.toggle("workspace_diagnostics") end, { desc = "workspace" })
vim.keymap.set("n", "<leader>xd", function() trouble.toggle("document_diagnostics") end, { desc = "document" })
vim.keymap.set("n", "<leader>xq", function() trouble.toggle("quickfix") end, { desc = "quickfix" })
vim.keymap.set("n", "<leader>xl", function() trouble.toggle("loclist") end, { desc = "loclist" })
vim.keymap.set("n", "gr", function() trouble.toggle("lsp_references") end, { desc = "lsp_references" })
vim.keymap.set("n", "gi", function() trouble.toggle("lsp_implementations") end, { desc = "lsp_implementations" })
