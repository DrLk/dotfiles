vim.g.mapleader = " "

-- NeoTree
vim.keymap.set("n", "<leader>e", ":Neotree float reveal<CR>")
-- vim.keymap.set("n", "<leader>E", ":Neotree left reveal<CR>")
vim.keymap.set("n", "<leader>o", ":Neotree float git_status<CR>")


local opt = { noremap = true, silent = true }
-- Navigation
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opt)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opt)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opt)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opt)
vim.keymap.set("n", "<leader>/", ":CommentToggle<CR>")

-- Splits
vim.keymap.set("n", "|", ":vsplit<CR>")
vim.keymap.set("n", "\\", ":split<CR>")

-- Other
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

-- Terminal
vim.keymap.set("n", "<leader>tf", ":ToggleTerm direction=float<CR>")
vim.keymap.set("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>")
vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical size=40<CR>")

-- Clipboard functionality (paste from system)
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')

-- Clipboard functionality (don't copy deleted text)
vim.api.nvim_set_keymap('n', 'd', '"dd', { noremap = true })
vim.api.nvim_set_keymap('n', 'x', '"xx', { noremap = true })

-- Quickfix
local function quickfix()
	vim.lsp.buf.code_action({
		filter = function(a)
			return a.isPreferred
		end,
		apply = true,
	})
end
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>q", quickfix, opts)

-- Quit
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", opts)
