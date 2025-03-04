return {
	"windwp/nvim-ts-autotag",
	event = {
		"InsertEnter *.tsx,*.jsx,*.html,*.vue,*.svelte,*.astro"
	},
	config = function()
		local autotag = require("nvim-ts-autotag")
		autotag.setup()
	end,
}
