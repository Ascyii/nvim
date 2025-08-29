return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		priority = 1000,
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				sync_install = true,
				ensure_installed = { "typst", "go", "bash", "python", "nix", "lua" },
				highlight = { enable = true },
				indent = { enable = true },
				fold = { enable = true },
			})
		end
	},
}
