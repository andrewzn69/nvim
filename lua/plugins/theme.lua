local hostname = vim.loop.os_gethostname()

if hostname == 'cheddar' or 'dev' then
	return {
		'sainnhe/everforest',
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.everforest_enable_italic = true
			vim.g.everforest_transparent_background = 2
			vim.g.everforest_background = 'hard'
			vim.g.everforest_better_performance = 1
			vim.cmd.colorscheme('everforest')

			vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#3A3A3A" })
		end,
	}
elseif hostname == 'arch' then
	return {
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local gruvbox = require("gruvbox")
			gruvbox.setup({
				terminal_colors = true,
				undercurl = true,
				underline = true,
				bold = true,
				italic = {
					strings = true,
					emphasis = true,
					comments = true,
					operators = false,
					folds = true,
				},
				strikethrough = true,
				invert_selection = false,
				invert_signs = false,
				invert_tabline = false,
				invert_intend_guides = false,
				inverse = true,
				contrast = "hard",
				palette_overrides = {
					dark1 = "#2C2C2C",
					dark0 = "#1D2022",
					bright_green = "#98971A",
					bright_yellow = "#D79921",
				},
				overrides = {
					MiniIndentscopeSymbol = { fg = "#A89984" },
					SignColumn = { bg = "#1D2022" },
					DiagnosticSignError = { bg = "NONE", fg = "#FB4934" },
					DiagnosticSignWarn = { bg = "NONE", fg = "#FFA500" },
					DiagnosticSignInfo = { bg = "NONE", fg = "#83A598" },
					DiagnosticSignHint = { bg = "NONE", fg = "#98971A" },
				},
				dim_inactive = false,
				transparent_mode = false,
			})
			vim.cmd("colorscheme gruvbox")
			vim.api.nvim_set_hl(0, "NormalFloat", {
				bg = "#1D2022"
			})
		end,
	}
elseif hostname == 'archnb' then
	return {
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		config = function()
			vim.cmd("colorscheme oxocarbon")
		end
	}
elseif hostname == 'fedoranb' then
	return {
		"shaunsingh/nord.nvim",
		lazy = false,
		config = function()
			vim.cmd("colorscheme nord")
		end
	}
else
	return {
		vim.cmd("colorscheme default")
	}
end
