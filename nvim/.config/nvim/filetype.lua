vim.filetype.add({
	extension = {
		gs = "javascript",
		tf = "terraform",
		tfvars = "terraform",
		hcl = "hcl",
	},
	filename = {
		["test"] = "ruby",
	},
	pattern = {
		-- Mark huge files to disable expensive features
		[".*"] = function(path, bufnr)
			return vim.bo[bufnr]
					and vim.bo[bufnr].filetype ~= "bigfile"
					and path
					and vim.fn.getfsize(path) > (1024 * 500) -- 500 KB
					and "bigfile"
				or nil
		end,
	},
})
