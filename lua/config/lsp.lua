-- lsp.lua
local lspconfig = require("lspconfig")
local cmp = require("cmp")


require("lspconfig").clangd.setup({
})


-- nvim-cmp setup
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

-- Capabilities for nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()


-- Example servers
local servers = { "gopls", "pyright", "lua_ls", "rust_analyzer", "clangd" }


require("mason-lspconfig").setup({
	ensure_installed = servers
})
for _, lsp in ipairs(servers) do
	local config = {
		capabilities = capabilities,
		on_attach = function(_, bufnr)
			local opts = { buffer = bufnr, noremap = true, silent = true }

			-- LSP core
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Jump to definition
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- Jump to declaration
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- Find references
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- Go to implementation
			vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts) -- Go to type definition
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)     -- Hover docs
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts) -- Signature help

			-- Refactor
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Rename symbol
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code actions

			-- Diagnostics
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- Previous diagnostic
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- Next diagnostic
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts) -- Show diagnostic
			vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, opts) -- List diagnostics

			-- Workspace
			vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
			vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
			vim.keymap.set("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)

			-- Formatting
			vim.keymap.set("n", "<leader>fff", function()
				vim.lsp.buf.format({ async = true })
			end, opts)
		end
	}
	if lsp == "lua_ls" then
		config.settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
			},
		}
	end

	if lsp == "clangd" then
		config.cmd = {
			"clangd",
			"--query-driver=/run/current-system/sw/bin/clang",
			"--compile-commands-dir=build",
		}
	end

	lspconfig[lsp].setup(config)
end
-- Diagnostic config (inline virtual text + signs + underlines)
vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- could be '●', '▎', 'x'
		spacing = 2,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})
