return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		priority = 1000,
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				sync_install = true,
				ensure_installed = { "css", "html", "rust", "php", "typst", "go", "bash", "python", "nix", "lua", "cpp", "c", "java" },
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				fold = { enable = true },

				ignore_install = {},
				modules = {},
			})
		end
	},
}
