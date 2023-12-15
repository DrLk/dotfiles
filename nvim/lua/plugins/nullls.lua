local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	sources = {
		-- null_ls.builtins.diagnostics.pylint.with({
		--     diagnostics_postprocess = function(diagnostic)
		--         diagnostic.code = diagnostic.message_id
		--     end,
		-- }),
		-- null_ls.builtins.formatting.isort,
		-- null_ls.builtins.formatting.black,
		-- null_ls.builtins.formatting.yapf,
		-- null_ls.builtins.formatting.autopep8,
        -- null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.eslint_d.with({
			filetypes = {
				"typescript",
				"javascript",
				"typescriptreact",
				"javascriptreact",
			},
		}),
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.diagnostics.ltrs,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.prettierd.with({
			filetypes = {
				"css",
				"scss",
				"less",
				"html",
				"json",
				"jsonc",
				"yaml",
				"markdown",
				"markdown.mdx",
				"graphql",
				"handlebars",
			},
		}),
	},

	on_attach = function(client, bufnr)
		-- if client.supports_method("textDocument/formatting") then
		-- 	vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		-- 	vim.api.nvim_create_autocmd("BufWritePre", {
		-- 		group = augroup,
		-- 		buffer = bufnr,
		-- 		callback = function()
		-- 			local lsp_format_modifications = require("lsp-format-modifications")
		-- 			lsp_format_modifications.format_modifications(client, bufnr)
		-- 		end,
		-- 	})
		-- end

		local lsp_format_modifications = require("lsp-format-modifications")
		lsp_format_modifications.attach(client, bufnr, { format_on_save = false })

		vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
			vim.lsp.buf.format({
				bufnr = bufnr,
				filter = function(client)
					return client.name == "null-ls"
				end,
			})
			-- vim.lsp.buf.formatting_sync()
		end, {})

		vim.api.nvim_buf_create_user_command(bufnr, "FormatModifications", function()
			local config = {

				-- The VCS to use. Possible options are: "git", "hg". Defaults to "git".
				vcs = "git",

				-- EXPERIMENTAL: when true, do not attempt to format the outermost empty
				-- lines in diff hunks, and do not touch hunks consisting of entirely empty
				-- lines. For some LSP servers, this can result in more intuitive behaviour.
				experimental_empty_line_handling = false,
			}

			lsp_format_modifications.format_modifications(client, bufnr, config)
		end, {})
	end,
})
