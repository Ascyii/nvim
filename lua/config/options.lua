
-- vim.o.textwidth = 80
-- vim.o.wrap = true;
vim.o.shiftwidth = 4;
vim.o.tabstop = 4;
vim.o.number = true;
vim.o.ignorecase = true;
vim.o.mouse= "";

-- this stands for undofile and should be always used because why not?
vim.o.udf = true;

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

if vim.g.diffm then
	vim.g.loaded_netrw = 0
	vim.g.loaded_netrwPlugin = 0
else
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
end
vim.opt.signcolumn = "yes"
