return {
	{
		"ThePrimeagen/harpoon",
	},
	{ "akinsho/toggleterm.nvim", config = true },
	{ "nvimdev/lspsaga.nvim", config = true },
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
		}},
	{
		-- treesitter
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- prio is needed for this
		--
		-- not needed cmd = { "NvimTreeToggle", "NvimTreeOpen" }, -- load only when you call these commands
		priority = 1000,
		config = function ()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = {"css", "typst", "bash", "markdown", "lua", "python", "rust", "c", "nix"},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end
	},
	{
		-- great typstar works only with luasnip
		ft = {"typst"},
		"Ascyii/typstar",
		dev = true,
		config = function()
			require("typstar").setup({
				typstarRoot = "~/projects/typstar",
				rnote = {
					assetsDir = 'assets',
					-- can be modified to e.g. export full pages; default is to try to export strokes only and otherwise export the entire document
					exportCommand = 'rnote-cli export selection --no-background --no-pattern --on-conflict overwrite --output-file %s all %s || rnote-cli export doc --no-background --no-pattern --on-conflict overwrite --output-file %s %s',
					filename = 'drawing-%Y-%m-%d-%H-%M-%S',
					fileExtension = '.rnote',
					fileExtensionInserted = '.rnote.svg', -- valid rnote export type
					uriOpenCommand = 'xdg-open', -- see comment above for excalidraw
					templatePath = {},
				},
			})
		end,
	},
	{'romgrk/barbar.nvim',
		dependencies = {
			'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
			--'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
		},
		init = function() vim.g.barbar_auto_setup = false end,
		cmd = {"BufferNext", "BufferPrevious" },
		opts = {
			clickable = false,
			tabpages = false,
			animations = false,
			icons = { filetype = { enabled = false } }

		},
		version = '^1.0.0', -- optional: only update when a new 1.x version is released
	},
	-- Does not work in nvim ?

	--		{"freitass/todo.txt-vim"},

	--	{
	--		'windwp/nvim-autopairs',
	--		enable = false,
	--		event = "InsertEnter",
	--		config = true
	--		-- use opts = {} for passing setup options
	--		-- this is equivalent to setup({}) function
	--	},
	{
		'nvim-lualine/lualine.nvim',
		-- dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		-- dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "echasnovski/mini.icons" },
		opts = {},
		cmd = { "FzfLua" }, -- load when you call :Telekasten
	},
	{
		-- this is the nvim tree but I dont use it yet
		"nvim-tree/nvim-tree.lua",
	},
	{
		"nvim-telescope/telescope.nvim", tag = '0.1.8',
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"ellisonleao/gruvbox.nvim",
	},
	-- Will see how this integrates with the existing workflow and what features I can impleemtn by 
	--	{
	--		"nvim-neorg/neorg",
	--		lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
	--		version = "*", -- Pin Neorg to the latest stable release
	--		config = true,
	--	},
	-- Disable lsp stuff
	--{
	--	-- lsp stuff
	--	"williamboman/mason.nvim",
	--	-- TODO: implement things like rename variables and stuff
	--	"williamboman/mason-lspconfig.nvim",
	--	"neovim/nvim-lspconfig",
	--},
	{
		-- LuaSnip configuration
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
			vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump(1) end, {silent = true})
			vim.keymap.set({"i", "s"}, "<C-H>", function() ls.jump(-1) end, {silent = true})
		end,
	},
	--	{
	--		"hrsh7th/nvim-cmp",
	--		event = "InsertEnter",
	--		dependencies = {
	--			"hrsh7th/cmp-nvim-lsp",
	--			"hrsh7th/cmp-buffer",
	--			"hrsh7th/cmp-path",
	--			"hrsh7th/cmp-cmdline",
	--			"L3MON4D3/LuaSnip",
	--			"saadparwaiz1/cmp_luasnip",
	--		},
	--		config = function()
	--			local cmp = require("cmp")
	--			local luasnip = require("luasnip")
	--
	--			cmp.setup({
	--				completion = {
	--					autocomplete = false,
	--				},
	--				snippet = {
	--					expand = function(args)
	--						require("luasnip").lsp_expand(args.body)
	--					end,
	--				},
	--				mapping = {
	--					["<Tab>"] = cmp.mapping(function(fallback)
	--						if cmp.visible() then
	--							cmp.select_next_item()
	--						elseif luasnip.expand_or_jumpable() then
	--							luasnip.expand_or_jump()
	--						else
	--							cmp.complete()
	--							vim.defer_fn(function()
	--								if cmp.visible() then cmp.select_next_item() end
	--							end, 10)
	--						end
	--					end, { "i", "s" }),
	--					["<S-Tab>"] = cmp.mapping(function(fallback)
	--						if cmp.visible() then
	--							cmp.select_prev_item()
	--						elseif luasnip.jumpable(-1) then
	--							luasnip.jump(-1)
	--						else
	--							fallback()
	--						end
	--					end, { "i", "s" }),
	--					["<CR>"] = cmp.mapping.confirm({ select = true }),
	--				},
	--				sources = cmp.config.sources({
	--					{ name = "nvim_lsp" },
	--					{ name = "luasnip" },
	--				}, {
	--						{ name = "buffer" },
	--					}),
	--			})
	--		end,
	--	},
	{
		'Ascyii/telekasten.nvim',
		dev = true,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			icons = {mappings = false,},
			-- set this delay so that its only used for 
			delay = 1500,
		},
	},
	-- LSP support
	{ "neovim/nvim-lspconfig" },
	{ "stevearc/aerial.nvim", opts = {} },
	{ "williamboman/mason.nvim", config = true },
	{ "williamboman/mason-lspconfig.nvim" },

	-- Autocompletion
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "saadparwaiz1/cmp_luasnip" },

	-- UI improvements
	--{ "nvimdev/lspsaga.nvim", config = true },
	--{ "folke/trouble.nvim", opts = {} },
	--{ "j-hui/fidget.nvim", tag = "legacy", config = true },
};
