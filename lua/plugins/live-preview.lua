return {
	"brianhuster/live-preview.nvim",
	event = "VeryLazy",
	config = function()
		require("livepreview.config").set({
			port = 6767,
			browser = "firefox",
		})
	end,
}
