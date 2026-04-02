local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.semanticHighlighting = true
capabilities.offsetEncoding = "utf-8"

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
        vim.lsp.buf.format({
            bufnr = bufnr,
            async = true,
        })
    end, {})

    vim.api.nvim_buf_create_user_command(bufnr, "FormatModifications", function()
        local lsp_format_modifications = require("lsp-format-modifications")
        lsp_format_modifications.format_modifications(client, bufnr)
    end, {})

    vim.keymap.set("n", "<Leader>lf", ":FormatModifications<CR>", { silent = true, desc = "Format modifications" })
end

vim.g.ale_echo_cursor = 0
vim.g.ale_linters = {
    python = { 'pycodestyle' },
    c = {},
    cpp = {},
    cuda = {},
}

local home = vim.fn.expand("~")
local null_ls = require("null-ls")
null_ls.setup({
    on_attach = on_attach,
    sources = {
        null_ls.builtins.formatting.yapf.with({
            extra_args = { "--style", "{based_on_style: pep8, column_limit: 120}" },
        }),
    },
})

-- Set shared capabilities and on_attach for all servers
vim.lsp.config('*', {
    capabilities = capabilities,
})

vim.lsp.config('basedpyright', {
    settings = {
        python = {
            pythonPath = home .. "/.venv/bin/python",
        },
        basedpyright = {
            autoImportCompletion = true,
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'openFilesOnly',
                useLibraryCodeForTypes = true,
                typeCheckingMode = 'off',
            },
        },
    },
})

vim.lsp.config('clangd', {
    cmd = {
        "clangd",
        "--background-index",
        "-j=12",
        "--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
        "--clang-tidy",
        "--clang-tidy-checks=*",
        "--all-scopes-completion",
        "--completion-style=detailed",
        "--header-insertion-decorators",
        "--header-insertion=iwyu",
        "--pch-storage=memory",
        "--log=error",
    },
})

vim.lsp.config('neocmake', {
    cmd = { "neocmakelsp", "stdio" },
})

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
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
        },
    },
})

vim.lsp.config('bashls', {
    filetypes = { 'sh', 'zsh' },
})

vim.lsp.config('cssls', {})

vim.lsp.config('golangci_lint_ls', {})

vim.lsp.config('rust_analyzer', {
    settings = {
        ["rust-analyzer"] = {
            diagnostics = { enable = true, experimental = { enable = true } },
        },
    },
})

vim.lsp.enable({
    'basedpyright',
    'clangd',
    'neocmake',
    'lua_ls',
    'bashls',
    'cssls',
    'golangci_lint_ls',
    'rust_analyzer',
})

-- Global mappings.
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
    local fmt = '<cmd>LspDoRename %d<CR>'

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { cword })
    vim.api.nvim_buf_set_keymap(buf, 'i', '<CR>', string.format(fmt, win), { silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', string.format(fmt, win), { silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ":close!<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', ":close!<CR>", { silent = true })
end

vim.api.nvim_create_user_command("LspDoRename", function(args)
    dorename(tonumber(args.args))
end, { nargs = 1 })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        on_attach(client, ev.buf)

        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<Leader>sa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<Leader>sr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<Leader>sl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<Leader>lr", rename, opts)
        vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, opts)
    end,
})
