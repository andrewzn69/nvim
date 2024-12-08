return {
	"windwp/nvim-ts-autotag",
	event = "VeryLazy",
	config = function()
		local autotag = require("nvim-ts-autotag")
		autotag.setup()
	end,
}
