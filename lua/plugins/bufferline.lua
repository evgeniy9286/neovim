return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local bufferline = require("bufferline")

			local gray = "#C0C0C0"
			local links = "#DAA520"

			bufferline.setup({
				options = {
					mode = "buffers",
					numbers = "none",
					color_icons = false,
					indicator = {
						style = "none",
					},
					modified_icon = "●",
					left_trunc_marker = "",
					right_trunc_marker = "",
					diagnostics = "nvim_lsp",
					always_show_bufferline = true,
				},
				highlights = {
					background = {
						fg = gray,
					},
					buffer_selected = {
						fg = links,
					},
					buffer_visible = {
						fg = gray,
					},
					separator = {
						bg = "#1e1e2e",
						fg = "#1e1e2e",
					},
					diagnostic = {},
				},
			})
		end,
	},
}
