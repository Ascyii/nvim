return {
	{
		"Ascyii/typstar",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"nvim-treesitter/nvim-treesitter",
		},
		dev = true,
		ft = { "typst" },
		keys = {
			{
				"<M-t>",
				"<Cmd>TypstarToggleSnippets<CR>",
				mode = { "n", "i" },
			},
			{
				"<M-j>",
				"<Cmd>TypstarSmartJump<CR>",
				mode = { "s", "i" },
			},
			{
				"<M-k>",
				"<Cmd>TypstarSmartJumpBack<CR>",
				mode = { "s", "i" },
			},
		},
		config = function()
			local typstar = require("typstar")
			typstar.setup({
				add_undo_breakpoints = true,
				typstarRoot = "~/projects/typstar",
				rnote = {
					assetsDir = 'typst-assets',
				},
			})
		end,
	},
}
