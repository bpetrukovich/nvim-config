-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Multi sessionizer integration
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww multi-sessionizer<CR>')

-- Better paste in visual mode (don't lose register content)
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste without corrupting the register' })

-- Open project view (uncomment if not using Oil)
-- vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'Open [P]roject [V]iew' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

vim.keymap.set('n', '<leader>yp', function()
  vim.fn.setreg('+', vim.fn.expand '%')
end, { desc = 'Yank relative path' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- IDE like move lines in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Atone lazy loading
vim.keymap.set('n', '<leader>u', '<cmd>Atone toggle<CR>', { desc = 'Toggle [U]ndotree' })

-- Obsidian lazy loading
vim.keymap.set('n', '<leader>oo', function()
  require('lazy').load { plugins = { 'obsidian.nvim' } }
end, { desc = 'Load Obsidian' })

vim.keymap.set('n', '<leader>dd', function()
  require('lazy').load { plugins = { 'nvim-dap' } }
end, { desc = 'Load Dap' })

vim.keymap.set('n', '<leader>wo', '<cmd>!wsl-open .<CR>', { desc = 'Open cwd in external file explorer' })

-- Delete conflicting keymaps
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grr')

-- Tabs
vim.keymap.set('n', '<leader>td', '<cmd>tabclose<CR>', { desc = 'Tab Delete' })
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<CR>', { desc = 'Tab New' })

local function escape(str)
  -- You need to escape these characters to work correctly
  local escape_chars = [[;,."|\]]
  return vim.fn.escape(str, escape_chars)
end

-- Recommended to use lua template string
local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

vim.opt.langmap = vim.fn.join({
  -- | `to` should be first     | `from` should be second
  escape(ru_shift)
    .. ';'
    .. escape(en_shift),
  escape(ru) .. ';' .. escape(en),
}, ',')
