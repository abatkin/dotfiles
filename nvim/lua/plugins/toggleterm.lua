return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
		lazy = false,
		opts = {
			winbar = {
				enabled = true,
			},
		},
		keys = {
			{ "<C-_>", "<cmd>ToggleTerm direction=float<cr>", desc = "Open ToggleTerm" },
			{
				"<leader>Tv",
				function()
					local count = vim.v.count1
					require("toggleterm").toggle(count, vim.o.columns * 0.4, vim.loop.cwd(), "vertical")
				end,
				desc = "ToggleTerm (vertical)",
			},
			{
				"<leader>Th",
				function()
					local count = vim.v.count1
					require("toggleterm").toggle(count, 10, vim.loop.cwd(), "horizontal")
				end,
				desc = "ToggleTerm (horizontal)",
			},
			{
				"<leader>Tn",
				"<cmd>ToggleTermSetName<cr>",
				desc = "Set term name",
			},
			{
				"<leader>Ts",
				"<cmd>TermSelect<cr>",
				desc = "Select term",
			},
		},
	},
}
