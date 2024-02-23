-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.showmatch = true

local includefile = vim.fn.expand("~/.nvim-local-pre.lua")
if vim.fn.filereadable(includefile) == 1 then
	dofile(includefile)
end
