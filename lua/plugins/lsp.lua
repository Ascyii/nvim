-- Prefilled with servers that have no dependencies
local servers = require("utils.functions").get_lsp_servers()

return {
	{
		"stevearc/aerial.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons"
		},
		config = true,
		keys = {
			{
				"<leader>ae",
				function()
					require("aerial")
					vim.cmd("AerialToggle")
				end

			},
			{
				"}",
				function()
					require("aerial")
					vim.cmd("AerialNext")
				end

			},
			{
				"{",
				function()
					require("aerial")
					vim.cmd("AerialPrev")
				end

			},


		},
	},
	{
		"nvimdev/lspsaga.nvim",
		opts = {
			lightbulb = {
				enable = false,
				enable_in_insert = false,
				sign = false,
				virtual_text = false,
			},
		},
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim"
		},
		priority = -10,
		config = function()
			require("mason").setup()

			-- Workaround for local zls
			local servers_modified = servers
			for i, v in ipairs(servers_modified) do
				if v == "zls" then
					table.remove(servers_modified, i)
					break
				end
			end

			require("mason-lspconfig").setup({
				ensure_installed = servers_modified,
				automatic_installation = true,
			})
		end,

	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
		},
		config = function()
			local cmp = require("cmp")
			local border = "single"
			local max_entries = 7

			cmp.setup({
				window = {
					completion = cmp.config.window.bordered({
						border = border,
						scrollbar = false,
					}),
					documentation = cmp.config.window.bordered({
						border = border,
						scrollbar = false,
					}),
				},
				snippet = {
					expand = function(args) require("luasnip").lsp_expand(args.body) end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
				performance = { max_view_entries = max_entries },
			})
		end
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local lspconfig = require("lspconfig")

			-- Custom overwrites for servers
			local server_settings = {}


			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(_, bufnr)
				local opts = { buffer = bufnr, noremap = true, silent = true }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

				vim.keymap.set("n", "]d", function()
					vim.diagnostic.jump({count=1, float=true})
				end, opts)
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.jump({count=-1, float=true})
				end, opts)

				vim.keymap.set("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set("n", "<leader>lwl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)

				vim.keymap.set("n", "<leader>ff", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end

			-- Setup servers manually
			for _, server in ipairs(servers) do
				local config = {
					capabilities = capabilities,
					on_attach = on_attach,
				}
				if server_settings[server] then
					config = vim.tbl_deep_extend("force", config, server_settings[server])
				end
				lspconfig[server].setup(config)
			end

			-- Add text in diagnostics
			vim.diagnostic.config({
				virtual_text = false,
			})
		end,
	},
}
