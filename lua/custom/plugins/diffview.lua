return {
  'sindrets/diffview.nvim',

  config = function()
    vim.keymap.set('n', '<leader>scc', '<cmd>DiffviewFileHistory<CR>', { desc = 'Commit History' })
    vim.keymap.set('n', '<leader>scb', '<cmd>DiffviewFileHistory %<CR>', { desc = 'File History' })
    vim.keymap.set('n', '<leader>scq', '<cmd>DiffviewClose<CR>', { desc = 'File History' })
    vim.keymap.set('n', '<leader>pr', '<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<CR>', { desc = 'Pull Request review' })
  end,
}
