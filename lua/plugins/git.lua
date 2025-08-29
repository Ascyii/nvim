return {
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
		dependencies = {
			"nvim-lua/plenary.nvim", -- Floating boarders
		},
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
		}
	},
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			local gitsigns = require("gitsigns")

			local function on_attach(bufnr)
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end


				map('n', ']c', function()
					if vim.wo.diff then
						vim.cmd.normal({ ']c', bang = true })
					else
						gitsigns.nav_hunk('next')
					end
					vim.cmd("normal! zz") -- center cursor
				end, { silent = true })

				map('n', '[c', function()
					if vim.wo.diff then
						vim.cmd.normal({ '[c', bang = true })
					else
						gitsigns.nav_hunk('prev')
					end
					vim.cmd("normal! zz") -- center cursor
				end, { silent = true })

				-- Actions
				map('n', '<leader>hs', gitsigns.stage_hunk)
				map('n', '<leader>hr', gitsigns.reset_hunk)

				map('v', '<leader>hs', function()
					gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
				end)

				map('v', '<leader>hr', function()
					gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
				end)

				map('n', '<leader>hS', gitsigns.stage_buffer)
				map('n', '<leader>hR', gitsigns.reset_buffer)
				map('n', '<leader>hp', gitsigns.preview_hunk)
				map('n', '<leader>hi', gitsigns.preview_hunk_inline)


				map('n', '<leader>hb', function()
					gitsigns.blame_line({ full = true })
				end)

				map('n', '<leader>hd', gitsigns.diffthis)

				map('n', '<leader>hD', function()
					gitsigns.diffthis('~')
				end)

				map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
				map('n', '<leader>hq', gitsigns.setqflist)

				-- Toggles
				map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
				-- map('n', '<leader>tw', gitsigns.toggle_word_diff)

				-- Text object
				map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
			end

			gitsigns.setup({ on_attach = on_attach })
		end
	}
}
