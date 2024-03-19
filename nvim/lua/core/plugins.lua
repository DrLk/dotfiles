local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "folke/trouble.nvim" },
        },
    },
    { "nvim-treesitter/nvim-treesitter" },
    { "neovim/nvim-lspconfig" },
    {
        "nvimdev/lspsaga.nvim",
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter' },
            { 'nvim-tree/nvim-web-devicons' }
        }
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "onsails/lspkind.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "tzachar/cmp-tabnine",                build = './install.sh', },
            { "L3MON4D3/LuaSnip" },
            { "saadparwaiz1/cmp_luasnip" },
            { "rafamadriz/friendly-snippets" },

        }
    },
    { "Badhi/nvim-treesitter-cpp-tools", dependencies = { "nvim-treesitter/nvim-treesitter" } },
    { "lewis6991/gitsigns.nvim" },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "linrongbin16/lsp-progress.nvim",
        },
    },
    { "williamboman/mason.nvim",                     build = ":MasonUpdate" },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "nvim-neotest/nvim-nio" },
            { "rcarriga/nvim-dap-ui", },
            { "theHamsta/nvim-dap-virtual-text", }
        }
    },
    { "Civitasv/cmake-tools.nvim",                   dependencies = { "nvim-lua/plenary.nvim" } },
    { "joechrisellis/lsp-format-modifications.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    -- { "codota/tabnine-nvim",                         build = "./dl_binaries.sh" },
    { "github/copilot.vim" },
    { "sindrets/diffview.nvim" },
    { "tpope/vim-fugitive" },

    { "akinsho/toggleterm.nvim",                     version = "*",                             config = true },
    { "nvimtools/none-ls.nvim" },
    { "windwp/nvim-autopairs" },
    { "terrortylor/nvim-comment" },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            "s1n7ax/nvim-window-picker",
        },
    },
    { "akinsho/bufferline.nvim",   dependencies = { "nvim-tree/nvim-web-devicons" } },
    {
        "linrongbin16/lsp-progress.nvim",
        event = { "VimEnter" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lsp-progress").setup({})
        end,
    },
    { "mtdl9/vim-log-highlighting" },
    { "joanrivera/vim-highlight" },
    { "folke/tokyonight.nvim" },
    { "folke/which-key.nvim" },
    { "ggandor/leap.nvim" },
    { "ggandor/flit.nvim",         dependencies = { "ggandor/leap.nvim" } },
    { "RRethy/vim-illuminate" },
    { "folke/trouble.nvim",        dependencies = { "nvim-tree/nvim-web-devicons" } },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            { "rcarriga/nvim-notify" },
            { "MunifTanjim/nui.nvim", },

        }
    },
    -- {
    --     "folke/flash.nvim",
    --     event = "VeryLazy",
    --     ---@type Flash.Config
    --     opts = {
    --         search = {
    --             exclude = {
    --                 "notify",
    --                 "cmp_menu",
    --                 "noice",
    --                 "flash_prompt",
    --                 function(win)
    --                     return vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "log"
    --                 end,
    --             },
    --         },
    --     },
    --     keys = {
    --         {
    --             "s",
    --             mode = { "n", "x", "o" },
    --             function()
    --                 require("flash").jump({
    --                     search = {
    --                         mode = function(str)
    --                             return "\\<" .. str
    --                         end,
    --                     },
    --                 })
    --             end,
    --             desc = "Flash",
    --         },
    --         {
    --             "S",
    --             mode = { "n", "o", "x" },
    --             function()
    --                 require("flash").treesitter()
    --             end,
    --             desc = "Flash Treesitter",
    --         },
    --         {
    --             "r",
    --             mode = "o",
    --             function()
    --                 require("flash").remote()
    --             end,
    --             desc = "Remote Flash",
    --         },
    --         {
    --             "R",
    --             mode = { "o", "x" },
    --             function()
    --                 require("flash").treesitter_search()
    --             end,
    --             desc = "Flash Treesitter Search",
    --         },
    --         {
    --             "<c-s>",
    --             mode = { "c" },
    --             function()
    --                 require("flash").toggle()
    --             end,
    --             desc = "Toggle Flash Search",
    --         },
    --     },
    -- },
})
