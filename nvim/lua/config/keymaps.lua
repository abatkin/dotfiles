-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map({ "i", "n", "s" }, "<esc>", function()
	LazyVim.cmp.actions.snippet_stop()
	return "<esc>"
end, { expr = true, desc = "Escape" })

local includefile = vim.fn.expand("~/.config/nvim-local/lua/config/keymaps.lua")
if vim.fn.filereadable(includefile) == 1 then
	dofile(includefile)
end
