local theme = 'gruvbox'

if theme == 'everforest' then
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
elseif theme == 'gruvbox' then
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
					dark0_hard = "#171A1C",
					dark1 = "#282C2D",
					dark2 = "#4D4C44",
					dark3 = "#4D4C44",
					dark4 = "#767161",
					gray = "#8C8570",
					light2 = "#D2C4A1",
					light3 = "#D2C4A1",
					light4 = "#A49B81",
					bright_green = "#98971A",
					bright_yellow = "#D79921",
					dark_red_hard = "#452925",
					dark_green_hard = "#2F3223",
					dark_aqua_hard = "#362F24",
				},
				overrides = {
					Normal = { bg = "NONE" },
					NormalNC = { bg = "NONE" },
					MiniIndentscopeSymbol = { fg = "#A49B81" },
					SignColumn = { bg = "NONE" },
					DiagnosticSignError = { bg = "NONE", fg = "#FB4934" },
					DiagnosticSignWarn = { bg = "NONE", fg = "#D79921" },
					DiagnosticSignInfo = { bg = "NONE", fg = "#83A598" },
					DiagnosticSignHint = { bg = "NONE", fg = "#8EC07C" },
					NormalFloat = { bg = "#232628" },
					FloatBorder = { bg = "#232628" },
					WinSeparator = { fg = "#2F3131" },
					Search = { fg = "#EBDBB2", bg = "#3D2D2B", reverse = false },
					IncSearch = { fg = "#171A1C", bg = "#B36656", reverse = false },
					WinBar = { bg = "NONE" },
					WinBarNC = { bg = "NONE" },
				},
				dim_inactive = false,
				-- transparent_mode = false,
			})
			vim.cmd("colorscheme gruvbox")
		end,
	}
elseif theme == 'oxocarbon' then
	return {
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		config = function()
			vim.cmd("colorscheme oxocarbon")
		end
	}
elseif theme == 'nord' then
	return {
		"shaunsingh/nord.nvim",
		lazy = false,
		config = function()
			vim.cmd("colorscheme nord")
		end
	}
else
	return {}
end
