local sessions = require("sessions")
sessions.setup({
    events = { "VimLeavePre" },
    session_filepath = vim.fn.stdpath("data") .. "/sessions",
    absolute = true,
})

local workspaces = require("workspaces")
workspaces.setup({
    hooks = {
        open_pre = function()
            sessions.stop_autosave({ save = true })
            vim.cmd("silent %bdelete!")

        end,
        open = function()
            sessions.load(nil, { silent = false })
            sessions.save(nil, { autosave = false })

            local options = require("plugins.cmaketools")
            require("cmake-tools").setup(options)
        end,
    }
})

vim.keymap.set("n", "<leader>wo", ":Telescope workspaces<CR>")
