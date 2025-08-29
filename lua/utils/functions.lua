-- General helper functions
local M = {}

function M.Sleep(n)
	os.execute("sleep " .. tonumber(n))
end

return M
