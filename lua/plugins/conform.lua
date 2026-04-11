return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				format_on_save = {
				--	timeout_ms = 500,
					lsp_fallback = false,
					async = false, -- Если поставить true, дергаться будет меньше, но файл может не успеть сохраниться
				},
				formatters_by_ft = {
					go = { "gopls", "goimports", "gofumpt", "golines" },
					templ = {"templ"},
					lua = { "stylua" },
					python = { "isort", "black" },
					rust = { "rustfmt", lsp_format = "fallback" },
					javascript = { "prettier" },
					typescript = { "standard_ts" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					angular = { "angular_html" },
					["angular.html"] = { "angular_html" },
					html = { "angular_html"},
					css = { "prettier" },
					scss = { "prettier" },
					json = { "prettier" },
				},
				formatters = {
					prettier = {
						args = { "--stdin-filepath", "$FILENAME" },
					},
					golines = {
						args = { "--max-len=60", "--base-formatter=gofmt" },
					},
					angular_html = {
						command = "prettier",
						args = {
							"--parser", "angular",
							"--single-attribute-per-line", "true",
							"--print-width", "60", -- поставь 40, если хочешь, чтоб ваще всё переносилось
							"--stdin-filepath", "$FILENAME"
						},
					},
					-- СПЕЦ-ФОРМАТТЕР ДЛЯ TS (чтобы точки с запятой не пропадали)
					standard_ts = {
						command = "prettier",
						args = {
							"--parser", "typescript",
							"--semi", "true",
							"--single-quote", "true",
							"--trailing-comma", "all",
							"--stdin-filepath", "$FILENAME",
							"--print-width", "60",
						},
					},
				},
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})
		end,
	},
}
