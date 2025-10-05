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
				ensure_installed = {"prismals", "lua_ls", "gopls", "ts_ls", "html", "htmx", "cssls", "cssmodules_ls", "templ", "sqlls", "cmake", "dockerls", "docker_compose_language_service", "postgres_lsp", "tailwindcss"}
			})
		end
	}
}
