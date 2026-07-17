return {
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		'williamboman/mason-lspconfig.nvim',
		config = function()
			require("mason-lspconfig").setup(
				{
					ensure_installed = {
						"angularls",
						"cmake",
						"cssls",
						"cssmodules_ls",
						"docker_compose_language_service",
						"dockerls",
						"eslint",
						"gopls",
						"html",
						"htmx",
						"lua_ls",
						"postgres_lsp",
						"prismals",
						"somesass_ls",
						"sqls",
						"tailwindcss",
						"templ",
						"ts_ls"
					}
				})
		end
	}
}
