local dap = require("dap")

vim.keymap.set("n", "<F5>", function()
    dap.continue()
end)

vim.keymap.set("n", "<F10>", function()
    dap.step_over()
end)
vim.keymap.set("n", "<F11>", function()
    dap.step_into()
end)
vim.keymap.set("n", "<F12>", function()
    dap.step_out()
end)
vim.keymap.set("n", "<Leader>b", function()
    dap.toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<Leader>B", function()
    dap.set_breakpoint()
end, { desc = "Set breakpoint" })
vim.keymap.set("n", "<Leader>lp", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, {desc = "Log point message breakpoint"})
vim.keymap.set("n", "<Leader>dr", function()
    require("dap").repl.open()
end, { desc = "Open repl" })
vim.keymap.set("n", "<Leader>dl", function()
    require("dap").run_last()
end, { desc = "Run last" })
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
    require("dap.ui.widgets").hover()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
    require("dap.ui.widgets").preview()
end)
vim.keymap.set("n", "<Leader>df", function()
    local widgets = require("dap.ui.widgets")
    widgets.centered_float(widgets.frames)
end, { desc = "Open frames" })
vim.keymap.set("n", "<Leader>ds", function()
    local widgets = require("dap.ui.widgets")
    widgets.centered_float(widgets.scopes)
end, { desc = "Open scopes" })

vim.api.nvim_create_autocmd('FileType', {
    desc = 'Close hover window',
    pattern = 'dap-float',
    callback = function(opts)
        vim.keymap.set("n", "q", ":close!<CR>", { silent = true, desc = "CLose hover window" })
    end,
})
vim.keymap.set("n", "q", function()
    local widgets = require("dap.ui.widgets")
    widgets.centered_float(widgets.scopes)
end)
local mason_registry = require("mason-registry")
local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
local codelldb_path = codelldb_root .. "adapter/codelldb"
local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"
dap.adapters.lldb = {
    type = "server",
    port = "${port}",
    host = "127.0.0.1",
    executable = {
        command = codelldb_path,
        args = { "--liblldb", liblldb_path, "--port", "${port}" },
    },
}

local file = require("utils.file")
dap.defaults.fallback.terminal_win_cmd = "10split new"
dap.configurations.cpp = {
    {
        name = "C++ Debug And Run",
        type = "lldb",
        request = "launch",
        program = function()
            -- First, check if exists CMakeLists.txt
            local cwd = vim.fn.getcwd()
            if file.exists(cwd, "CMakeLists.txt") then
                -- Then invoke cmake commands
                -- Then ask user to provide execute file
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            else
                local fileName = vim.fn.expand("%:t:r")
                -- create this directory
                os.execute("mkdir -p " .. "bin")
                local cmd = "!g++ -g % -o bin/" .. fileName
                -- First, compile it
                vim.cmd(cmd)
                -- Then, return it
                return "${fileDirname}/bin/" .. fileName
            end
        end,
        expressions = "native",
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
        args = {},
    },
}

dap.configurations.c = {
    {
        name = "C++ Debug And Run",
        type = "lldb",
        request = "launch",
        program = function()
            -- First, check if exists CMakeLists.txt
            local cwd = vim.fn.getcwd()
            if file.exists(cwd, "CMakeLists.txt") then
                -- Then invoke cmake commands
                -- Then ask user to provide execute file
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            else
                local fileName = vim.fn.expand("%:t:r")
                -- create this directory
                os.execute("mkdir -p " .. "bin")
                local cmd = "!g++ -g % -o bin/" .. fileName
                -- First, compile it
                vim.cmd(cmd)
                -- Then, return it
                return "${fileDirname}/bin/" .. fileName
            end
        end,
        expressions = "native",
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
        args = {},
    },
}

require("dapui").setup()

local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- require("dap.ext.vscode").load_launchjs(".nvim/launch.json", { lldb = { "c", "cpp", "rust" } })
