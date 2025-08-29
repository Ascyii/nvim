-- Prefilled with lsp that have no dependencies
local servers = { "lua_ls", "rust_analyzer", "denols" }

local function populate_servers()
	if vim.fn.executable("go") == 1 then
		table.insert(servers, "gopls")
	else
		vim.notify("[mason] Skipping gopls (go not found)", vim.log.levels.WARN)
	end

	if vim.fn.executable("npm") == 1 then
		table.insert(servers, "pyright")
		table.insert(servers, "clangd")
		table.insert(servers, "bashls")
	else
		vim.notify("[mason] Skipping install of some lsp (npm not found)", vim.log.levels.WARN)
	end

	if vim.fn.executable("cargo") == 1 then
		table.insert(servers, "nil_ls")
	else
		vim.notify("[mason] Skipping nil (cargo not found)", vim.log.levels.WARN)
	end
end
populate_servers()

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
		priority = -10;
		config = function()
			require("mason").setup()


			require("mason-lspconfig").setup({
				ensure_installed = servers,
				automatic_installation = true,
			})
		end,

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
			cmp.setup({
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
			local server_settings = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
						},
					},
				},
			}


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

				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				--vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, opts)

				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set("n", "<leader>wl", function()
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
				virtual_text = true,
			})
		end,
	},
}
