local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

-- https://github.com/prettier-solidity/prettier-plugin-solidity
null_ls.setup({
	debug = false,
	sources = {
		formatting.prettier.with({
			extra_filetypes = { "toml" },
			extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
		}),
		formatting.black.with({ extra_args = { "--fast" } }),
		formatting.stylua,
		formatting.google_java_format,
		diagnostics.flake8,
		formatting.gofmt.with({
			extra_filetypes = { "go" },
		}),
		formatting.goimports.with({
			extra_filetypes = { "go" },
			extra_args = { "-srcdir", "$DIRNAME" },
		}),
		--formatting.goimports_reviser.with({
		--	extra_filetypes = { "go" },
		--	extra_args = { "-file-path", "$FILENAME", "-output", "stdout" },
		--}),
		formatting.rustfmt.with({
			extra_filetypes = { "rs" },
			extra_args = { "--emit=stdout" },
		}),
	},
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = true
		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
	end,
})
