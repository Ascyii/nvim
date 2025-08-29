-- General helper functions
local M = {}

function M.sleep(n)
	os.execute("sleep " .. tonumber(n))
end

--- @return {}
function M.get_lsp_servers()
	local servers = { "lua_ls" }

	-- persistent state file
	local state_file = vim.fn.stdpath("state") .. "/mason_skipped_jonas.json"

	-- load previous warnings
	local warned = {}
	local ok, data = pcall(vim.fn.readfile, state_file)
	if ok and #data > 0 then
		local decoded = vim.fn.json_decode(data)
		if decoded then warned = decoded end
	end

	local function save_state()
		vim.fn.writefile({ vim.fn.json_encode(warned) }, state_file)
	end

	local function warn_once(key, msg)
		if not warned[key] then
			vim.notify(msg, vim.log.levels.WARN)
			warned[key] = true
			save_state()
		end
	end

	local function populate_servers()
		if vim.fn.executable("go") == 1 then
			table.insert(servers, "gopls")
		else
			warn_once("gopls", "[mason] Skipping gopls (go not found)")
		end

		if vim.fn.executable("npm") == 1 then
			table.insert(servers, "pyright")
			table.insert(servers, "clangd")
			table.insert(servers, "bashls")
		else
			warn_once("npm", "[mason] Skipping pyright/clangd/bashls (npm not found)")
		end

		if vim.fn.executable("cargo") == 1 then
			if vim.fn.executable("nix") == 1 then
				table.insert(servers, "nil_ls")
			else
				warn_once("nix", "[mason] Skipping nil_ls (nix not found)")
			end
			table.insert(servers, "rust_analyzer")
		else
			warn_once("cargo", "[mason] Skipping nil_ls/rust_analyzer (cargo not found)")
		end

		if vim.fn.executable("deno") == 1 then
			table.insert(servers, "denols")
		else
			warn_once("deno", "[mason] Skipping denols (deno not found)")
		end
	end

	populate_servers()
	return servers
end

return M
