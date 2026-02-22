return {
	"tajirhas9/muslim.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		latitude = 32.8140,
		longitude = -96.9489,
		utc_offset = -6, -- CST (change to -5 during daylight saving time)
		method = "ISNA",
		school = "standard",
		refresh = 5,
	},
	config = function(_, opts)
		local muslim = require("muslim")
		muslim.setup(opts)
	end,
}
