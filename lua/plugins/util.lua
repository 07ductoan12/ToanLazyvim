local M = {
	{
		"rbong/vim-flog",
		lazy = true,
		cmd = { "Flog", "Flogsplit", "Floggit" },
		dependencies = {
			"tpope/vim-fugitive",
		},
	},
	{
		"giusgad/pets.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim", "giusgad/hologram.nvim" },
		config = true,
	},
	{ import = "lazyvim.plugins.extras.util.mini-hipatterns" },
	{ import = "lazyvim.plugins.extras.util.project" },
	{ import = "lazyvim.plugins.extras.util.startuptime" },
}

if ConfigVariable.util.rest then
	table.insert(M, {
		{ import = "lazyvim.plugins.extras.util.rest" },
	})
end

if ConfigVariable.util.sql then
	table.insert(M, {
		{ import = "lazyvim.plugins.extras.lang.sql" },
	})
end

return M