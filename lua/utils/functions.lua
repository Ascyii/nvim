-- General helper functions
local M = {}

function M.sleep(n)
	os.execute("sleep " .. tonumber(n))
end

--- @return string
function M.get_cwd()
	local cwd = vim.fn.getcwd()
	local home = os.getenv("HOME")

	if cwd:sub(1, #home) == home then
		return "~" .. cwd:sub(#home + 1)
	else
		return cwd
	end
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

		if vim.fn.executable("php") == 1 then
			table.insert(servers, "intelephense")
		else
			warn_once("php", "[mason] Skipping intelephense (php not found)")
		end

		if vim.fn.executable("hls") == 1 then
			table.insert(servers, "hls")
		else
			warn_once("haskell", "[mason] Skipping hls (hls not found)")
		end

		if vim.fn.executable("npm") == 1 then
			if vim.fn.executable("clangd") == 1 then
				table.insert(servers, "clangd")
			end
			table.insert(servers, "pyright")
			table.insert(servers, "bashls")
			table.insert(servers, "cssls")
			table.insert(servers, "html")
			table.insert(servers, "jsonls")
		else
			warn_once("npm", "[mason] Skipping npm related (npm not found)")
		end

		if vim.fn.executable("cargo") == 1 then
			if vim.fn.executable("nix") == 1 then
				table.insert(servers, "nil_ls")
			else
				warn_once("nix", "[mason] Skipping nil_ls and nixfmt (nix not found)")
			end
			table.insert(servers, "rust_analyzer")
		else
			warn_once("cargo", "[mason] Skipping nil_ls/rust_analyzer (cargo not found)")
		end

		if vim.fn.executable("deno") == 1 then
			table.insert(servers, "ts_ls")
		else
			warn_once("deno", "[mason] Skipping denols and tsserver (deno not found)")
		end

		if vim.fn.executable("zls") == 1 then
			table.insert(servers, "zls")
		end
	end

	populate_servers()
	return servers
end

return M
