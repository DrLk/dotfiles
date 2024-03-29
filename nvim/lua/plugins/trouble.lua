local trouble = require("trouble")
trouble.setup({
    auto_close = true,                -- auto close when there are no items
    auto_open = false,                -- auto open when there are items
    auto_preview = true,              -- automatically open preview when on an item
    auto_refresh = false,             -- auto refresh when open
    focus = true,                     -- Focus the window when opened
    restore = true,                   -- restores the last location in the list when opening
    follow = true,                    -- Follow the current item
    indent_guides = true,             -- show indent guides
    max_items = 200,                  -- limit number of items that can be displayed per section
    multiline = true,                 -- render multi-line messages
    pinned = false,                   -- When pinned, the opened trouble window will be bound to the current buffer
    ---@type trouble.Window.opts
    win = { size = { height = 20 } }, -- window options for the results window. Can be a split or a floating window.
    -- Window options for the preview window. Can be a split, floating window,
    -- or `main` to show the preview in the main editor window.
    -- Key mappings can be set to the name of a builtin action,
    -- or you can define your own custom action.
    ---@type table<string, string|trouble.Action>
    keys = {
        ["?"] = "help",
        r = "refresh",
        R = "toggle_refresh",
        q = "close",
        o = "jump_close",
        ["<esc>"] = "cancel",
        ["<cr>"] = "jump",
        ["<2-leftmouse>"] = "jump",
        ["<c-s>"] = "jump_split",
        ["<c-v>"] = "jump_vsplit",
        -- go down to next item (accepts count)
        -- j = "next",
        ["}"] = "next",
        ["]]"] = "next",
        ["j"] = "next",
        -- go up to prev item (accepts count)
        -- k = "prev",
        ["{"] = "prev",
        ["[["] = "prev",
        ["k"] = "prev",
        i = "inspect",
        p = "preview",
        P = "toggle_preview",
        zo = "fold_open",
        zO = "fold_open_recursive",
        zc = "fold_close",
        zC = "fold_close_recursive",
        za = "fold_toggle",
        zA = "fold_toggle_recursive",
        zm = "fold_more",
        zM = "fold_close_all",
        zr = "fold_reduce",
        zR = "fold_open_all",
        zx = "fold_update",
        zX = "fold_update_all",
        zn = "fold_disable",
        zN = "fold_enable",
        zi = "fold_toggle_enable",
    },
}
)
vim.keymap.set("n", "<leader>xx", function() trouble.close() end, { desc = "toggle" })
vim.keymap.set("n", "<leader>xw", function()
    trouble.close()
    trouble.open("workspace_diagnostics")
end, { desc = "workspace" })
vim.keymap.set("n", "<leader>xd", function() trouble.open("document_diagnostics") end, { desc = "document" })
vim.keymap.set("n", "<leader>xq", function() trouble.open("quickfix") end, { desc = "quickfix" })
vim.keymap.set("n", "<leader>xl", function() trouble.open("loclist") end, { desc = "loclist" })
vim.keymap.set("n", "gr", function() trouble.open("lsp_references") end, { desc = "lsp_references" })
vim.keymap.set("n", "gi", function() trouble.open("lsp_implementations") end, { desc = "lsp_implementations" })
