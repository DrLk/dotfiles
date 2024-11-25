local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.semanticHighlighting = true
capabilities.offsetEncoding = "utf-8"

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

    vim.keymap.set("n", "<Leader>lf", ":FormatModifications<CR>", { silent = true, desc = "Format modifications" })
end
local lspconfig = require("lspconfig")
lspconfig.pylsp.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                -- formatter options
                black = { enabled = false },
                autopep8 = {
                    enabled = false,
                },
                yapf = {
                    enabled = true,
                    -- args = "--style='{ based_on_style: pep8, column_limit: 120 }'"
                },
                -- linter options
                pylint = { enabled = true, executable = "pylint" },
                ruff = { enabled = true },
                pyflakes = { enabled = true },
                pycodestyle = {
                    enabled = true,
                    maxLineLength = 100
                },
                -- type checker
                pylsp_mypy = {
                    enabled = false,
                    -- overrides = { "--python-executable", py_path, true },
                    report_progress = false,
                    live_mode = false
                },
                -- auto-completion options
                jedi_completion = {
                    enabled = false,
                    fuzzy = true,
                },
                -- import sorting
                isort = { enabled = true },
            },
        },
    },
})

lspconfig.pyright.setup(
    {
        settings = {
            pyright = {
                autoImportCompletion = true,
            },
            python = {
                analysis =
                {
                    autoSearchPaths = true,
                    diagnosticMode = 'openFilesOnly',
                    useLibraryCodeForTypes = true,
                    typeCheckingMode = 'off'
                }
            }
        }
    })

-- Function to get the path to clangd from Mason
local function get_clangd_path()
    local mason_registry = require("mason-registry")
    local clangd_root = mason_registry.get_package("clangd"):get_install_path()
    local bin_path = ""
    mason_registry.get_package("clangd"):get_receipt()
        :if_present(
        ---@param receipt InstallReceipt
            function(receipt)
                bin_path = receipt.links.bin["clangd"]
            end
        )

    return vim.fn.resolve(clangd_root .. "/" .. bin_path)
end
lspconfig.clangd.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--background-index",
        "-j=12",
        "--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
        "--clang-tidy",
        "--clang-tidy-checks=*",
        "--all-scopes-completion",
        "--cross-file-rename",
        "--completion-style=detailed",
        "--header-insertion-decorators",
        "--header-insertion=iwyu",
        "--pch-storage=memory",
        "--suggest-missing-includes",
        -- "--offset-encoding=utf-16",
        -- "--compile-commands-dir=./"
    },
})
lspconfig.neocmake.setup({})
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT'
                -- path = runtime_path,
            },
            workspace = {
                library = {
                    ["~/.config/nvim"] = true,
                    ["~/.local/share/nvim/runtime/lua"] = true,
                    ["~/.local/share/nvim/runtime/lua/vim"] = true,
                    ["~/.local/share/nvim/runtime/lua/vim/lsp"] = true,
                    ["~/.local/share/nvim/lazy"] = true,
                },
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                -- globals = { "vim" },
            },
        },
    },
})
lspconfig.bashls.setup({
    capabilities = capabilities,
    filetypes = { 'sh', 'zsh', }
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
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
end)
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end)
vim.keymap.set("n", "<leader>ld", vim.diagnostic.setloclist)

local function dorename(win)
    local new_name = vim.trim(vim.fn.getline('.'))
    vim.api.nvim_win_close(win, true)
    vim.lsp.buf.rename(new_name)
end

local function rename()
    local opts = {
        relative = 'cursor',
        row = 1,
        col = 0,
        width = 30,
        height = 1,
        style = 'minimal',
        border = 'rounded',
        title_pos = 'center',
        title = 'Rename To'
    }
    local cword = vim.fn.expand('<cword>')
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, opts)
    local fmt = '<cmd>lua Rename.dorename(%d)<CR>'

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { cword })
    vim.api.nvim_buf_set_keymap(buf, 'i', '<CR>', string.format(fmt, win), { silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', string.format(fmt, win), { silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ":close!<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', ":close!<CR>", { silent = true })
end

_G.Rename = {
    rename = rename,
    dorename = dorename
}

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
        -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
        -- vim.keymap
        vim.keymap
            .set('n', '<Leader>sa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<Leader>sr', vim.lsp.buf.remove_workspace_folder,
            opts)
        vim.keymap.set('n', '<Leader>sl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<Leader>lr", Rename.rename, opts)
        vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, opts)
        -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        -- vim.keymap.set("n", "<Leader>lf", function()
        --     vim.lsp.buf.format({ async = true })
        -- end, opts)
    end,
})
