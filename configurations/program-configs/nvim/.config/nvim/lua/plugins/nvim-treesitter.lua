return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({ "javascript", "lua", "python", "c", "cpp", "json", "http" })
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "lua", "javascript", "python", "c", "cpp", "json", "http" },
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
