return {
	"serenevoid/kiwi.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		{
			name = "personal",
			path = "/home/abatkin/local/notes-personal",
		},
	},
	keys = {
		{
			"<leader>ww",
			function()
				require("kiwi").open_wiki_index()
			end,
			desc = "Wiki",
		},
	},
}
