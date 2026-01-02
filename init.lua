vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

-- banner disable
vim.g.netrw_banner = 0

-- Load configuration modules
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy'

-- modeline. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
