-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Not recommended, quickfix -> Trouble
vim.api.nvim_create_autocmd('BufRead', {
  callback = function(ev)
    if vim.bo[ev.buf].buftype == 'quickfix' then
      vim.schedule(function()
        vim.cmd [[cclose]]
        vim.cmd [[Trouble qflist open]]
      end)
    end
  end,
})

-- Commented filetype specific indentation settings
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'html',
--   command = 'setlocal shiftwidth=2 tabstop=2',
-- })
--
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'javascript',
--   command = 'setlocal shiftwidth=2 tabstop=2',
-- })
--
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'typescript',
--   command = 'setlocal shiftwidth=2 tabstop=2',
-- })
--
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'css',
--   command = 'setlocal shiftwidth=2 tabstop=2',
-- })
