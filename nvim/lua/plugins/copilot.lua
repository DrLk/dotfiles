vim.keymap.set("i", "<C-l>", "copilot#Accept('<CR>')", {
    expr = true,
    replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
vim.cmd("Copilot disable")

vim.api.nvim_create_autocmd({ "LspAttach" }, {
    pattern = "*",
    callback = function(args)
        vim.cmd("Copilot enable")
    end
})
