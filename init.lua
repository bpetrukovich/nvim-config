vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- banner disable
vim.g.netrw_banner = 0

-- Load configuration modules
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lazy'

-- Load custom configurations
require 'custom'

-- modeline. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
