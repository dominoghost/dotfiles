return {
	"nvim-telescope/telescope.nvim",
	tag = "v0.2.0",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		pickers = {
			live_grep = {
				file_ignore_patterns = { "node_modules", ".git" },
				additional_args = function(_)
					return { "--hidden" }
				end,
				no_ignore = true,
			},
			find_files = {
				file_ignore_patterns = { "node_modules", ".git" },
				hidden = true,
				no_ignore = true,
			},
		},
	},
}
