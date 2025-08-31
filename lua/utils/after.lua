local function rounded_border()
	return { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
end

-- Buffer the original fuction
local nvim_open_win = vim.api.nvim_open_win

-- Set color to a slight gray
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'None', fg = '#a0a0a0' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'None' })

-- Border overwrite
vim.api.nvim_open_win = function(buf, enter, opts)
	opts = opts or {}

	if opts.border == nil then
		opts.border = rounded_border()
	end

	return nvim_open_win(buf, enter, opts)
end
