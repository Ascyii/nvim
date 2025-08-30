return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets"
		},
		version = "v2.*",
		build = "make install_jsregexp",
		event = "InsertEnter",
		config = function()
			local ls = require("luasnip")

			-- Load snippets
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })

			ls.config.setup({
				enable_autosnippets = true,
				store_selection_keys = '<Tab>',
			})
			vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-H>", function() ls.jump(-1) end, { silent = true })
		end,
	},
}
