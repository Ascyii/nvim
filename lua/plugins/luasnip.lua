return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		event = "InsertEnter",
		config = function()
			local ls = require("luasnip")
			ls.config.setup({
				enable_autosnippets = true,
				store_selection_keys = '<Tab>',
			})
			vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-H>", function() ls.jump(-1) end, { silent = true })
		end,
	},
}
