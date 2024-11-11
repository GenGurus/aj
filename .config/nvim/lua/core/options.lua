vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- UI/General
opt.number = true
opt.relativenumber = true
opt.ignorecase = true
opt.cursorline = false
opt.clipboard = "unnamedplus"
opt.termguicolors = true
opt.confirm = true
opt.mouse = "a"
opt.undofile = true
opt.swapfile = false
opt.conceallevel = 1
opt.scrolloff = 12
opt.wrap = true
opt.linebreak = true
opt.spelllang = "en_us"
opt.showtabline = 0

opt.swapfile = true -- Don't use swapfile
opt.updatetime = 0 -- Faster completion
opt.encoding = "utf-8" -- The encoding displayed
opt.fileencoding = "utf-8" -- The encoding written to file
opt.smartindent = true -- Makes indenting smart
opt.iskeyword:append("-") -- Treat dash separated words as a word text object"
opt.clipboard = "unnamedplus" -- Copy paste between vim and everything else
opt.smarttab = true -- Makes tabbing smarter will realize you have 2 vs 4
opt.expandtab = true -- Converts tabs to spaces
opt.autoindent = true -- Good auto indent
opt.autochdir = true -- Your working directory will always be the same as your working directory
opt.incsearch = true -- opt. incremental search
opt.mouse = "a" -- Enable mouse support
opt.shell = "/bin/bash" -- opt.your shell to bash or zsh
opt.shortmess:append("sI") -- Disable nvim intro
vim.cmd([[set nobackup]]) -- Creates a backup file
vim.cmd([[set nowritebackup]]) -- Creates a backup file i guess
vim.cmd([[set formatoptions-=cro]]) -- Stop newline continution of comments
vim.cmd([[set complete+=kspell]]) -- Auto complete with spellcheck
vim.cmd([[set completeopt=menuone,longest]]) -- Auto complete menu (It's pretty great)
vim.cmd([[set nocompatible]])

-- opt.tab width
opt.tabstop = 2
opt.shiftwidth = 2
opt.autoindent = true
opt.expandtab = true

opt.ruler = true -- Show the cursor position all the time
opt.conceallevel = 0 -- So that I can see `` in markdown files
opt.virtualedit = "onemore" -- With This option you can move the cursor one character over the end
opt.ignorecase = true -- Ignores case when searching
opt.smartcase = true -- Turns on case sensitive search when letters are capitalized
opt.cursorline = true -- Enable highlighting of the current line
opt.shiftwidth = 2 -- Change the number of space characters inserted for indentation
opt.showtabline = 1 -- Always show tabs
opt.cmdheight = 1 -- More space for displaying messages
opt.numberwidth = 5 -- opt number column width to 2 {default 4}
opt.foldenable = false -- Disable folding text
vim.cmd([[setlocal conceallevel=2]]) -- Syntax conceal for markdown
vim.cmd([[set noshowmode]]) -- We don't need to see things like -- INSERT -- anymore
vim.cmd([[syntax enable]]) -- Enables syntax highlighing
vim.cmd([[set t_Co=256]])

-- memory, cpu
opt.hidden = true -- Required to keep multiple buffers open multiple buffers
opt.timeoutlen = 500 -- By default timeoutlen is 1000 ms
opt.lazyredraw = false -- Disable lazyredraw
opt.synmaxcol = 240 -- Max column for syntax highlight
--opt.updatetime = 700
