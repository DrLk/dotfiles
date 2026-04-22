local ensure_installed = { "lua", "cpp", "python", "bash", "zsh", "dockerfile" }

require 'nvim-treesitter'.install(ensure_installed)

vim.api.nvim_create_autocmd('FileType', {
    pattern = vim.list_extend({ "markdown" }, ensure_installed),
    callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

require 'treesitter-context'.setup {
    enable = true,
    multiwindow = false,
    max_lines = 0,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 20,
    trim_scope = 'outer',
    mode = 'cursor',
    separator = nil,
    zindex = 20,
    on_attach = nil,
}
