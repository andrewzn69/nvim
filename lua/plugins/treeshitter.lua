return {
  {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	cmd = { "TSInstall", "TSBufEnable", "TSBufDisable" },
	build = ":TSUpdate",
	config = function()
		local treesitter = require("nvim-treesitter")

		local parsers = {
			"astro",
			"bash",
			"css",
			"c_sharp",
			"dockerfile",
			"elixir",
			"go",
			"gotmpl",
			"graphql",
			"gitcommit",
			"gitignore",
			"git_config",
			"git_rebase",
			"hcl",
			-- "helm",
			"html",
			"hyprlang",
			"javascript",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
			"nix",
			"php",
			"prisma",
			"python",
			"rasi",
			"regex",
			"ruby",
			"rust",
			"scss",
			"sql",
			"terraform",
			"tsx",
			"typescript",
			"vim",
			"vue",
			"yaml",
			"yuck",
		}

		-- v1 setup() only processes install_dir; call install explicitly
		---@diagnostic disable-next-line
		treesitter.setup({})
		vim.schedule(function()
			require("nvim-treesitter.install").install(parsers)
		end)


		-- v1 removed highlight management from the plugin; enable it explicitly per buffer
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})

		vim.treesitter.language.register("gotmpl", { "gohtmltmpl", "gotexttmpl", "gotmpl", "helm" })

		vim.filetype.add({
			pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
		})

		local r = require("utils.remaps")
		r.noremap("n", "<leader>dp", function()
			vim.treesitter.inspect_tree({ command = "botright 60vnew" })
		end, "treesitter playground")

		r.noremap("n", "<C-e>", function()
			local result = vim.treesitter.get_captures_at_cursor(0)
			print(vim.inspect(result))
		end, "show treesitter capture group")

		r.map_virtual("zi", "init selection")
		r.map_virtual("zi", "expand node")
		r.map_virtual("zo", "expand scope")
		r.map_virtual("zd", "decrement scope")

		-- r.map_virtual("af", "Function outer motion")
		-- r.map_virtual("if", "Function inner motion")
		-- r.map_virtual("ac", "Class outer motion")
		-- r.map_virtual("ic", "Class inner motion")
		--
		-- r.map_virtual("ax", "Attribute (html, xml) outer motion")
		-- r.map_virtual("ix", "Attribute (html, xml) inner motion")
		--
		-- r.map_virtual("ak", "Json key outer motion")
		-- r.map_virtual("ik", "Json key inner motion")
		--
		-- r.map_virtual("av", "Json value outer motion")
		-- r.map_virtual("iv", "Json value inner motion")
		--
		-- r.which_key("fp", "parameters")
		--
		r.map_virtual("<leader>rp", "swap parameter to next")
		r.map_virtual("<leader>rP", "swap parameter to previous")
		--
		-- r.map_virtual("]m", "Go to next function (start)")
		-- r.map_virtual("]M", "Go to next function (end)")
		--
		-- r.map_virtual("]]", "Go to next class (start)")
		-- r.map_virtual("][", "Go to next class (end)")
		--
		-- r.map_virtual("[m", "Go to previous function (start)")
		-- r.map_virtual("[M", "Go to previous function (end)")
		--
		-- r.map_virtual("[[", "Go to previous class (start)")
		-- r.map_virtual("[]", "Go to previous class (end)")
	end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufReadPost",
  },
}
