return {
	{
		"zgs225/gomodifytags.nvim",
		cmd = { "GoAddTags", "GoRemoveTags", "GoInstallModifyTagsBin" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("gomodifytags").setup() -- Optional: You can add any specific configuration here if needed.
		end,
	},
}
