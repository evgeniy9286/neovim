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
			local servers = { 'gopls', 'ccls', 'cmake', 'templ' }
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
						--						["ui.diagnostic.staticcheck"] = true,
						templateExtensions = { "templ" },
						staticcheck = true,
						analyses = {
							unusedparams = true,
							shadow = true,
						},
						--		hints = {
						--			assignVariableTypes = true,
						--			compositeLiteralFields = true,
						--			constantValues = true,
						--			functionTypeParameters = true,
						--			parameterNames = true,
						--			rangeVariableTypes = true,
						--		},
						codelenses = {
							generate = true,
							test = true,
						},
						usePlaceholders = true,
						completeUnimported = true,
					},
				},
				filetypes = { "go", "gomod", "gowork", "gotmpl", "templ" },
			})

			lspconfig.sqls.setup({
				settings = {
					sqls = {
						connections = {
							{
								driver = 'postgresql',
								dataSourceName =
								'host=127.0.0.1 port=5432 user=postgres password=pass dbname=nechan_lesson sslmode=disable',
							},
						},
					},
				},
			})

			--			lspconfig.sqlls.setup({})


			require('lspconfig').ts_ls.setup({
				settings = {
					typescript = {
						preferences = {
							includeCompletionsForModuleExports = true,
							includePackageJsonAutoImports = "all",
							importModuleSpecifierPreference = "non-relative",
						},
						check = {
							unusedVariables = "warning",
						},
						suggest = {
							completeFunctionCalls = true,
						},
						inlayHints = {
							includeInlayParameterNameHints = 'none',
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = false,
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypeHints = false,
							includeInlayFunctionLikeReturnTypeHints = false,
							includeInlayEnumMemberValueHints = false,
						}
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = 'none',
							includeInlayVariableTypeHints = false,
						}
					}
				},
				on_attach = function(client, bufnr)
					if client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
					end
				end,
			})

			lspconfig.angularls.setup({
				capabilities = capabilities,
				filetypes = { 'typescript', 'html', 'typescript.angular', 'typescript.tsx', 'angular.html', "htmlangular" },
				root_dir = require('lspconfig.util').root_pattern("angular.json", "nx.json", "package.json"),

				on_new_config = function(new_config, new_root_dir)
					if not new_root_dir then
						new_config.cmd = {} -- отменяем запуск, если это не Angular-проект
					end
				end,

				settings = {
					angular = {
						forceStrictTemplates = true,
						forLoopVariableTypes = false,
						ifAliasTypes = false,
						letDeclarationTypes = false,
						eventParameterTypes = false,
						propertyBindingTypes = false,
						pipeOutputTypes = false,
						parameterNameHints = "none",
					},
					html = {
						format = {
							wrapAttributes = "force",
							wrapLineLength = 100,
						}
					}
				},

				on_attach = function(client, bufnr)
					if type(on_attach) == "function" then
						on_attach(client, bufnr)
					end

					vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })

					client.server_capabilities.documentFormattingProvider = false
				end,
			})


			--			lspconfig.angularls.setup({
			--			on_attach = on_attach,
			--			capabilities = capabilities,
			--			filetypes = { 'typescript', 'html', 'typescript.angular', 'typescript.tsx', 'angular.html' },
			--			root_dir = require('lspconfig.util').root_pattern("angular.json", "nx.json", "package.json"),
			--			settings = {
			--				angular = {
			--					forceStrictTemplates = true,
			--					suggest = {
			--						includeInlayHints = false,
			--					}
			--				},
			--				html = {
			--					format = {
			--						wrapAttributes = "force", -- Это заставит переносить атрибуты
			--						wrapLineLength = 80,
			--					}
			--				}
			--			},
			--			on_attach = function(client, bufnr)
			--				if client.server_capabilities.inlayHintProvider then
			--					vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
			--					client.server_capabilities.documentFormattingProvider = false
			--				end
			--			end,
			--		})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			lspconfig.cssmodules_ls.setup({
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				root_dir = require('lspconfig').util.root_pattern("package.json", ".git"),
				on_attach = function(client, bufnr)
					client.server_capabilities.definitionProvider = false
				end,
			})

			lspconfig.somesass_ls.setup({
				filetypes = { "scss", "sass" }, -- забирает только синтаксис Sass
				root_dir = lspconfig.util.root_pattern("angular.json", "package.json", ".git"),
				settings = {
					somesass = {
						scanImportedFiles = true,
						-- Исправляем слэши путей для Windows, чтобы сервер не слеп
						includePaths = { vim.fs.normalize(vim.fn.getcwd() .. "/src") },
						suggestAllFromOpenDocument = false,
					}
				},
				capabilities = capabilities,
			})

			--			lspconfig.cssls.setup({
			--			root_dir = lspconfig.util.root_pattern("angular.json", "package.json", ".git"),
			--			settings = {
			--				css = {
			--					validate = true,
			--					importHelpers = true,
			--				},
			--				scss = {
			--					validate = true,
			--					scanImportedFiles = true,
			--				},
			--			},
			--			capabilities = require('cmp_nvim_lsp').default_capabilities(),
			--		})

			--	lspconfig.somesass_ls.setup {
			--		settings = {
			--			somesass = {
			--				scanImportedFiles = true,
			--				includePaths = { vim.fn.getcwd() .. "/src" },
			--				suggestAllFromOpenDocument = false,
			--			}
			--		},
			--		root_dir = require('lspconfig').util.root_pattern("package.json", "angular.json", ".git"),
			--	}

			--		lspconfig.html.setup({
			--		on_attach = on_attach,
			--		capabilities = capabilities,
			--		filetypes = { "html", "angular" },
			--		init_options = {
			--			configurationSection = { "html", "css", "javascript" },
			--			embeddedLanguages = {
			--				css = true,
			--				javascript = true
			--			},
			--			provideFormatter = true
			--		},
			--		settings = {
			--			html = {
			--				format = {
			--					wrapAttributes = "force", -- Это заставит переносить атрибуты
			--					wrapLineLength = 80,
			--				}
			--			}
			--		}
			--	})

			--	lspconfig.html.setup({
			--	on_attach = function(client, bufnr)
			--		if vim.bo[bufnr].filetype == "templ" then
			--			client.server_capabilities.documentFormattingProvider = false
			--			client.server_capabilities.documentRangeFormattingProvider = false
			--			end
			--			if type(on_attach) == "function" then
			--				on_attach(client, bufnr)
			--			end
			--		end,
			--		capabilities = capabilities,
			--		filetypes = { "html", "angular", "templ" },
			--		init_options = {
			--			configurationSection = { "html", "css", "javascript", "templ", "angular" },
			--			embeddedLanguages = {
			--				css = true,
			--				javascript = true
			--			},
			--			provideFormatter = true
			--		},
			--		settings = {
			--			html = {
			--				format = {
			--					wrapAttributes = "force",
			--					wrapLineLength = 40,
			--				},
			--			}
			--		}
			--	})

			lspconfig.html.setup({
				on_attach = function(client, bufnr)
					if vim.bo[bufnr].filetype == "templ" then
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end
					-- common_on_attach(client, bufnr)
				end,

				capabilities = capabilities,
				filetypes = { "html", "htmlangular", "templ" },

				init_options = {
					configurationSection = { "html", "css", "javascript", "templ", "htmlangular" },
					embeddedLanguages = {
						css = true,
						javascript = true
					},
					provideFormatter = false
				},

				settings = {
					html = {
						format = {
							wrapAttributes = "force",
							wrapLineLength = 40,
						},
						customData = {
							"https://githubusercontent.com"
						}
					}
				}
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

			--		lspconfig.postgrestools.setup({})

			lspconfig.postgres_lsp.setup({
				root_dir = lspconfig.util.root_pattern(".git", "go.mod", "sql"),
				on_attach = function(client, bufnr)
				end,
				--			cmd = { "postgrestools", "lsp-proxy" },
				filetypes = { "sql", "go" },
				root_markers = { "postgrestools.jsonc" }
			})

			lspconfig.tailwindcss.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { "tailwindcss-language-server", "--stdio" },
				filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "gohtmltmpl", "haml", "handlebars", "hbs", "html", "htmlangular", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "templ", "go" },
				settings = {
					tailwindCSS = {
						classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
						includeLanguages = {
							eelixir = "html-eex",
							elixir = "phoenix-heex",
							eruby = "erb",
							heex = "phoenix-heex",
							htmlangular = "html",
							templ = "html",
							typescript = "typescript"
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
						experimental = {
							classRegex = {
								{ "(?:class|ngClass|routerLinkActive)\\s*=\\s*['\"`]([^'\"`]*?)['\"`]",       "([^\\s]+)" },
								{ "\\[(?:class|ngClass|routerLinkActive)\\]\\s*=\\s*['\"`]([^'\"`]*?)['\"`]", "([^\\s]+)" },
								{ "class=\\s*['\"`]([^'\"`]*?)['\"`]",                                        "(?:class|className)=\\s*['\"`]([^'\"`]*?)['\"`]" },
								{ "routerLinkActive\\s*=\\s*['\"`]([^'\"`]*?)['\"`]" },
								{ "\\[routerLinkActive\\]\\s*=\\s*['\"`]([^'\"`]*?)['\"`]" },
								{ "ngClass\\s*=\\s*['\"`]([^'\"`]*?)['\"`]" },
								{ "\\[ngClass\\]\\s*=\\s*['\"`]([^'\"`]*?)['\"`]" },
								{ "class=\\s*['\"`]([^'\"`]*?)['\"`]",                                        "(?:class|className)=\\s*['\"`]([^'\"`]*?)['\"`]" },
								{ "ngClass\\s*=\\s*['\"`]([^'\"`]*?)['\"`]" },
								{ "\\[ngClass\\]\\s*=\\s*['\"`]([^'\"`]*?)['\"`]" },
								{ "class\\.[a-zA-O0-9-_]+\\s*=\\s*['\"`]([^'\"`]*?)['\"`]" },
								{ "template\\s*:\\s*`([^`]*?)`" },
							},
						},
						validate = true
					}
				},
				capabilities = require('cmp_nvim_lsp').default_capabilities(),
			})

			--			require('nvim-treesitter.configs').setup({
			--			ensure_installed = { "html", "javascript", "templ", "go" },
			--			highlight = { enable = true },
			--		})

			vim.filetype.add({ extension = { templ = "templ" } })

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.templ",
				callback = function()
					local clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
					if #clients > 0 then
						vim.lsp.buf.format()
					end
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
					local opts = { buffer = ev.buf }
					--	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'gd', function()
						local ok, telescope = pcall(require, 'telescope.builtin')
						if ok then
							-- Если есть одно совпадение — прыгает сразу.
							-- Если несколько — открывает список выбора Telescope.
							telescope.lsp_definitions({
								reuse_win = true,
								jump_type = "never",
							})
						else
							-- Запасной вариант, если Telescope не установлен
							vim.lsp.buf.definition()
						end
					end, opts)
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
