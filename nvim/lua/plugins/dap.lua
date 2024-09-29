local dap = require("dap")

vim.keymap.set("n", "<leader>i", function()
    dap.down()
end, { desc = "Go down in current stacktrace without stepping." })

vim.keymap.set("n", "<leader><S-i>", function()
    dap.up()
end, { desc = "Go up in current stacktrace without stepping." })

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

dap.adapters.gdb = {
    id = 'gdb',
    type = 'executable',
    command = 'gdb',
    args = { '--quiet', '--interpreter=dap' },
}
local mason_registry = require("mason-registry")
local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
local codelldb_path = codelldb_root .. "adapter/codelldb"
local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    host = "127.0.0.1",
    executable = {
        command = codelldb_path,
        args = { "--liblldb", liblldb_path, "--port", "${port}" },
    },
}

dap.adapters.lldbdap = {
    type = "executable",
    name = "lldb-dap",
    command = os.getenv("HOME") .. "/.local/bin/lldb-dap",
}

local file = require("utils.file")
dap.defaults.fallback.terminal_win_cmd = "10split new"
dap.configurations.cpp = {
    {
        name = "C++ Debug And Run",
        type = "lldbdap",
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
        showDisassembly = "never",
        args = {},
    },
}

dap.configurations.c = {
    {
        name = "C++ Debug And Run",
        type = "lldbdap",
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
        showDisassembly = "never",
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
require("dapui").setup({
    icons = { expanded = "", collapsed = "", current_frame = "" },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    element_mappings = {},
    expand_lines = vim.fn.has("nvim-0.7") == 1,
    force_buffers = true,
    layouts = {
        {
            -- You can change the order of elements in the sidebar
            elements = {
                -- Provide IDs as strings or tables with "id" and "size" keys
                {
                    id = "scopes",
                    size = 0.25, -- Can be float or integer > 1
                },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks",      size = 0.25 },
                { id = "watches",     size = 0.25 },
            },
            size = 40,
            position = "left", -- Can be "left" or "right"
        },
        {
            elements = {
                "repl",
            },
            size = 1,
            position = "top", -- Can be "bottom" or "top"
        },
        {
            elements = {
                "console",
            },
            size = 20,
            position = "bottom", -- Can be "bottom" or "top"
        },
    },
    floating = {
        max_height = nil,
        max_width = nil,
        border = "single",
        mappings = {
            ["close"] = { "q", "<Esc>" },
        },
    },
    controls = {
        enabled = vim.fn.exists("+winbar") == 1,
        element = "repl",
        icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
            disconnect = "",
        },
    },
    render = {
        max_type_length = 0,  -- Can be integer or nil.
        max_value_lines = 100, -- Can be integer or nil.
        indent = 1,
    },
})

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

require("nvim-dap-virtual-text").setup {
    enabled = true,                        -- enable this plugin (the default)
    enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true,               -- show stop reason when stopped for exceptions
    commented = false,                     -- prefix virtual text with comment string
    only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
    all_references = true,                -- show virtual text on all all references of the variable (not only definitions)
    clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
    --- A callback that determines how a variable is displayed or whether it should be omitted
    --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
    --- @param buf number
    --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
    --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
    --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
    --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
    display_callback = function(variable, buf, stackframe, node, options)
      if options.virt_text_pos == 'inline' then
        return ' = ' .. variable.value
      else
        return variable.name .. ' = ' .. variable.value
      end
    end,
    -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
    virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

    -- experimental features:
    all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = true,                    -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
                                           -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function(details)
        if (vim.api.nvim_buf_line_count(details.buf) > 5000) then
            vim.cmd("DapVirtualTextDisable")
        else
            vim.cmd("DapVirtualTextEnable")
        end
    end
})
-- require("dap.ext.vscode").load_launchjs(".nvim/launch.json", { lldb = { "c", "cpp", "rust" } })
