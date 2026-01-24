-- Luacheck configuration for Neovim
globals = {
	"vim",
	"Snacks",
}

-- Neovim uses Lua 5.1/LuaJIT
std = "luajit"

-- Ignore some common patterns
ignore = {
	"212", -- Unused argument (common in callbacks)
}
