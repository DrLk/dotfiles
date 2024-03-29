require("cmake-tools").setup({
    cmake_command = "cmake",         -- this is used to specify cmake command path
    cmake_regenerate_on_save = true, -- auto generate when save CMakeLists.txt
    cmake_generate_options = {
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
        "-G Ninja",
        "-DBOOST_INSTALL_PREFIX=" .. os.getenv( "HOME" ) .. "/.local/boost/1.75",
        "-DCHECK_GLIBC_SYMBOLS_VERSION=OFF",
        "-DSTATIC_LINK_FUSE=OFF",
        "-DSTATIC_LINK_ATOMIC=OFF",
        "-DBUILD_WEBUI=0",
        "-DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=mold",
        "-DCMAKE_SHARED_LINKER_FLAGS=-fuse-ld=mold",
        "-DCMAKE_MODULE_LINKER_FLAGS=-fuse-ld=mold" }, -- this will be passed when invoke `CMakeGenerate`
    cmake_build_options = {},                 -- this will be passed when invoke `CMakeBuild`
    -- support macro expansion:
    --       ${kit}
    --       ${kitGenerator}
    --       ${variant:xx}
    cmake_build_directory = "../build/${variant:buildType}", -- this is used to specify generate directory for cmake, allows macro expansion
    cmake_soft_link_compile_commands = true,            -- this will automatically make a soft link from compile commands file to project root dir
    cmake_compile_commands_from_lsp = false,            -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
    cmake_kits_path = nil,                              -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
    cmake_variants_message = {
        short = { show = true },                        -- whether to show short message
        long = { show = true, max_length = 40 },        -- whether to show long message
    },
    cmake_dap_configuration = {                         -- debug settings for cmake
        name = "cpp",
        type = "lldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
        expressions = "native",
        args = {"1", "0.0.0.0", "10200", "127.0.0.1", "10100"},
    },
    cmake_executor = {                   -- executor to use
        name = "quickfix",               -- name of the executor
        opts = {},                       -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
        default_opts = {                 -- a list of default and possible values for executors
            quickfix = {
                show = "only_on_error",         -- "always", "only_on_error"
                position = "belowright", -- "bottom", "top"
                size = 20,
                encoding = "utf-8",      -- if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
                auto_close_when_success = true, -- typically, you can use it with the "always" option;
            },
            overseer = {
                new_task_opts = {},               -- options to pass into the `overseer.new_task` command
                on_new_task = function(task) end, -- a function that gets overseer.Task when it is created, before calling `task:start`
            },
            terminal = {},                        -- terminal executor uses the values in cmake_terminal
        },
    },
    cmake_runner = {                     -- runner to use
        name = "terminal",               -- name of the runner
        opts = {},                       -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
        default_opts = {                 -- a list of default and possible values for runners
            quickfix = {
                show = "only_on_error",         -- "always", "only_on_error"
                position = "belowright", -- "bottom", "top"
                size = 10,
                encoding = "utf-8",
                auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
            },
            toggleterm = {
                direction = "float",   -- 'vertical' | 'horizontal' | 'tab' | 'float'
                close_on_exit = false, -- whether close the terminal when exit
                auto_scroll = true,    -- whether auto scroll to the bottom
            },
            overseer = {
                new_task_opts = {
                    strategy = {
                        "toggleterm",
                        direction = "horizontal",
                        autos_croll = true,
                        quit_on_exit = "success"
                    }
                },   -- options to pass into the `overseer.new_task` command
                on_new_task = function(task)
                end, -- a function that gets overseer.Task when it is created, before calling `task:start`
            },
            terminal = {
                name = "Main Terminal",
                prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
                split_direction = "horizontal", -- "horizontal", "vertical"
                split_size = 11,

                -- Window handling
                single_terminal_per_instance = true,  -- Single viewport, multiple windows
                single_terminal_per_tab = true,       -- Single viewport per tab
                keep_terminal_static_location = true, -- Static location of the viewport if avialable

                -- Running Tasks
                start_insert = false,       -- If you want to enter terminal with :startinsert upon using :CMakeRun
                focus = false,              -- Focus on terminal when cmake task is launched.
                do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
            },
        },
    },
    cmake_notifications = {
        enabled = true, -- show cmake execution progress in nvim-notify
        spinner = {
            "⠋",
            "⠙",
            "⠹",
            "⠸",
            "⠼",
            "⠴",
            "⠦",
            "⠧",
            "⠇",
            "⠏",
        },                     -- icons used for progress display
        refresh_rate_ms = 100, -- how often to iterate icons
    },
})

vim.keymap.set("n", "<leader>mg", "<cmd>CMakeGenerate<CR>", { desc = "Generate" })
vim.keymap.set("n", "<leader>mx", "<cmd>CMakeGenerate!<CR>", { desc = "Clean and generate" })
vim.keymap.set("n", "<leader>mb", "<cmd>CMakeBuild<CR>", { desc = "Build" })
vim.keymap.set("n", "<leader>mr", "<cmd>CMakeRun<CR>", { desc = "Run" })
vim.keymap.set("n", "<leader>md", "<cmd>CMakeDebug<CR>", { desc = "Debug" })
vim.keymap.set("n", "<leader>my", "<cmd>CMakeSelectBuildType<CR>", { desc = "Select Build Type" })
vim.keymap.set("n", "<leader>mt", "<cmd>CMakeSelectBuildTarget<CR>", { desc = "Select Build Target" })
vim.keymap.set("n", "<leader>ml", "<cmd>CMakeSelectLaunchTarget<CR>", { desc = "Select Launch Target" })
vim.keymap.set("n", "<leader>mo", "<cmd>CMakeOpen<CR>", { desc = "Open CMake Console" })
vim.keymap.set("n", "<leader>mc", "<cmd>CMakeClose<CR>", { desc = "Close CMake Console" })
vim.keymap.set("n", "<leader>mi", "<cmd>CMakeInstall<CR>", { desc = "Intall CMake target" })
vim.keymap.set("n", "<leader>mn", "<cmd>CMakeClean<CR>", { desc = "Clean CMake target" })
vim.keymap.set("n", "<leader>ms", "<cmd>CMakeStop<CR>", { desc = "Stop CMake Process" })
vim.keymap.set("n", "<leader>mp", "<cmd>cd %:p:h<CR> ", { desc = "Change pwd to current file" })
