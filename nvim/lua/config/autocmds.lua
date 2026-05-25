-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local includefile = vim.fn.expand("~/.config/nvim-local/lua/config/autocmds.lua")
if vim.fn.filereadable(includefile) == 1 then
	dofile(includefile)
end
