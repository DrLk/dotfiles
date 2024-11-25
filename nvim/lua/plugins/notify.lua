require("noice").setup({
    routes = {
        {
            view = "notify",
            filter = { event = "msg_showmode" },
        },
    },
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
            ["vim.lsp.util.rename"] = true,
        },
        progress = {
            enabled = true,
        },
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
    },
    views = {
        -- Configure the relative floating window for rename
        rename = {
            backend = "popup",
            relative = "cursor", -- Position relative to the cursor
            position = {
                row = 1,
                col = 0,
            },
            size = {
                width = 25,      -- Width of the rename window
                height = "auto", -- Height automatically adjusts
            },
            border = {
                style = "rounded", -- Rounded border style
                padding = { 1, 1 },
            },
            win_options = {
                winblend = 10, -- Transparency level
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            },
        },
    },
})
