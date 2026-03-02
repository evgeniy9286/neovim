return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "go", "gomod", "gosum", "lua", "typescript", "javascript", "tsx", "angular", "templ", "html", "css", "scss", "http", "json", "dockerfile", "gitcommit", "gitignore", "git_config", "git_rebase", "gitattributes", "make", "markdown", "sql", "toml", "vue" },
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
		per_filetype = {
    ["html" ] = {
      enable_close = false
    }
  }
	},
}
