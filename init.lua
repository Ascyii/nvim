-- Nvim config by Jonas Hahn

-- set a diff flag
-- this stands for diff mode
if vim.o.diff then
  vim.g.diffm = true
else
  vim.g.diffm = false
end

require("config.init")

