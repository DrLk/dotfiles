local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
        vim.lsp.buf.format({
            bufnr = bufnr,
        })
        -- vim.lsp.buf.formatting_sync()
    end, {})

    vim.api.nvim_buf_create_user_command(bufnr, "FormatModifications", function()
        local lsp_format_modifications = require("lsp-format-modifications")
        lsp_format_modifications.format_modifications(client, bufnr)
    end, {})
end
local lspconfig = require("lspconfig")
lspconfig.pylsp.setup({
    on_attach = on_attach,
    settings = {
        pylsp = {
            plugins = {
                -- formatter options
                black = { enabled = false },
                autopep8 = {
                    enabled = true,
                },
                yapf = {
                    enabled = false,
                    args = '--style={based_on_style: pep8 column_limit: 100}'
                },
                -- linter options
                pylint = { enabled = true, executable = "pylint" },
                ruff = { enabled = true },
                pyflakes = { enabled = true },
                pycodestyle = { enabled = true },
                -- type checker
                pylsp_mypy = {
                    enabled = true,
                    -- overrides = { "--python-executable", py_path, true },
                    report_progress = false,
                    live_mode = false
                },
                -- auto-completion options
                jedi_completion = { fuzzy = true },
                -- import sorting
                isort = { enabled = true },
            },
        },
    },
})
-- lspconfig.pyright.setup({})
lspconfig.tsserver.setup({})
lspconfig.prismals.setup({})
lspconfig.clangd.setup({ on_attach = on_attach })
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            workspace = {
                library = {
                    ["/usr/share/nvim/runtime/lua"] = true,
                    ["/usr/share/nvim/runtime/lua/vim"] = true,
                    ["/usr/share/nvim/runtime/lua/vim/lsp"] = true
                },
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                -- globals = { "vim" },
            },
        },
    },
})
-- lspconfig.stylua.setup({})
lspconfig.cssls.setup({ capabilities = capabilities })
lspconfig.golangci_lint_ls.setup({})
lspconfig.rust_analyzer.setup({
    settings = {
        ["rust-analyzer"] = {
            diagnostics = { enable = true, experimental = { enable = true } },
        },
    },
})
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>lD", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>ld", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
        -- vim.keymap
        -- vim.keymap
        --     .set('n', '<Leader>sa', vim.lsp.buf.add_workspace_folder, opts)
        -- vim.keymap.set('n', '<Leader>sr', vim.lsp.buf.remove_workspace_folder,
        --                opts)
        -- vim.keymap.set('n', '<Leader>sl', function()
        --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)
        -- vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, opts)
        -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        -- vim.keymap.set("n", "<Leader>lf", function()
        --     vim.lsp.buf.format({ async = true })
        -- end, opts)
        vim.keymap.set("n", "<Leader>lf", ":FormatModifications<CR>", { silent = true, desc = "Format modifications" })
    end,
})
