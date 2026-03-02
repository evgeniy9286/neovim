return {
	{
		"neovim/nvim-lspconfig",
		configg = function()
			require("indentmini").setup() -- use default config
		end,
		config = function()
			require("nvim-autopairs").setup({
				disable_filetype = { "TelescopePrompt", "vim" },
			})
			local lspconfig = require("lspconfig")
			local servers = { 'gopls', 'ccls', 'cmake', 'tsserver', 'templ' }
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end
			lspconfig.lua_ls.setup({
				settings = { Lua = { diagnostics = { globals = { "vim", "require" } } } },
			})
			lspconfig.gopls.setup({
				settings = {
					gopls = {
						templateExtensions = { "templ" },
					},
				},
				filetypes = { "go", "gomod", "gowork", "gotmpl", "templ" },
			})
			lspconfig.angularls.setup({
				on_attach = on_attach, -- ваша стандартная функция с маппингами
				capabilities = capabilities,
				filetypes = { 'typescript', 'html', 'typescript.angular', 'typescript.tsx' },
				root_dir = require('lspconfig.util').root_pattern("angular.json", "nx.json", "package.json"),
			})
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			lspconfig.cssls.setup({
				capabilities = capabilities,
			})
			lspconfig.cssmodules_ls.setup({})
			lspconfig.html.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "html", "templ", "angular" },
			})
			lspconfig.htmx.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "html", "templ" },
			})
			lspconfig.templ.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
			lspconfig.dockerls.setup({
				cmd = { "docker-langserver", "--stdio" },
				filetypes = { "dockerfile" },
				root_markers = { "Dockerfile" }
			})
			lspconfig.docker_compose_language_service.setup({
				cmd = { "docker-compose-langserver", "--stdio" },
				filetypes = { "yaml.docker-compose" },
				root_markers = { "docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml" }
			})
			lspconfig.prismals.setup({})
			lspconfig.postgres_lsp.setup({
				cmd = { "postgrestools", "lsp-proxy" },
				filetypes = { "sql" },
				root_markers = { "postgrestools.jsonc" }
			})
			lspconfig.tailwindcss.setup({
				cmd = { "tailwindcss-language-server", "--stdio" },
				filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "gohtmltmpl", "haml", "handlebars", "hbs", "html", "htmlangular", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "templ" },
				settings = {
					tailwindCSS = {
						classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
						includeLanguages = {
							eelixir = "html-eex",
							elixir = "phoenix-heex",
							eruby = "erb",
							heex = "phoenix-heex",
							htmlangular = "html",
							templ = "html"
						},
						lint = {
							cssConflict = "warning",
							invalidApply = "error",
							invalidConfigPath = "error",
							invalidScreen = "error",
							invalidTailwindDirective = "error",
							invalidVariant = "error",
							recommendedVariantOrder = "warning"
						},
						validate = true
					}
				}
			})

			vim.filetype.add({ extension = { templ = "templ" } })

			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = "*.templ",
				callback = function()
					-- Форматируем файл через templ fmt
					vim.fn.jobstart({ "templ", "fmt", vim.fn.expand("%") }, {
						on_exit = function()
							-- Опционально: запускаем генерацию go-кода сразу после формата
							-- vim.fn.jobstart({ "templ", "generate" })
							vim.cmd("edit!") -- Перезагружаем буфер, чтобы увидеть изменения
						end,
					})
				end,
			})

			--		require('gomodifytags').setup({ transformation = "snakecase" })
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Symbol" })
					vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<Leader>lf", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},
}
