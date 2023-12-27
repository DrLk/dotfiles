local dap = require("dap")

vim.keymap.set("n", "<F5>", function()
    dap.continue()
end, { desc = "Continue" })

vim.keymap.set("n", "<C-F5>", function()
    dap.terminate()
end, { desc = "Terminate" })

vim.keymap.set("n", "<F10>", function()
    dap.step_over()
end, { desc = "Step over" })
vim.keymap.set("n", "<F11>", function()
    dap.step_into()
end, { desc = "Step into" })
vim.keymap.set("n", "<F12>", function()
    dap.step_out()
end, { desc = "Step out" })
vim.keymap.set("n", "<Leader>b", function()
    dap.toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<Leader>B", function()
    dap.set_breakpoint()
end, { desc = "Set breakpoint" })
vim.keymap.set("n", "<Leader>lp", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "Log point message breakpoint" })
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
-- vim.keymap.set("n", "q", function()
--     local widgets = require("dap.ui.widgets")
--     widgets.centered_float(widgets.scopes)
-- end)
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

dap.adapters.python = {
    type = "executable",
    command = os.getenv("HOME") .. "/.venv/bin/python",
    args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = function()
            -- First, check if exists CMakeLists.txt
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        pythonPath = function()
            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                return cwd .. "/.venv/bin/python"
            elseif vim.fn.executable(os.getenv("HOME") .. "/.venv/bin/python") == 1 then
                return os.getenv("HOME") .. "/.venv/bin/python"
            else
                return "/usr/bin/python"
            end
        end,
        cwd = "${workspaceFolder}",
        args = {},
    }
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
