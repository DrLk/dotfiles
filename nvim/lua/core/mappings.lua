vim.g.mapleader = " "

local opt = { noremap = true, silent = true }
-- NeoTree
vim.keymap.set("n", "<leader>e", ":Neotree float reveal<CR>", opt)
-- vim.keymap.set("n", "<leader>E", ":Neotree left reveal<CR>")
vim.keymap.set("n", "<leader>o", ":Neotree float git_status<CR>", opt)


-- Navigation
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opt)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opt)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opt)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opt)
vim.keymap.set("n", "<leader>/", ":CommentToggle<CR>", opt)

-- Splits
vim.keymap.set("n", "|", ":vsplit<CR>")
vim.keymap.set("n", "\\", ":split<CR>")

-- Other
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", opt)

-- Terminal
vim.keymap.set("n", "<leader>tf", ":ToggleTerm direction=float<CR>", opt)
vim.keymap.set("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>", opt)
vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical size=40<CR>", opt)

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
vim.keymap.set("n", "<leader>q", quickfix, opt)

-- Quit
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", opt)
