return {
  'akinsho/git-conflict.nvim',
  version = '*',
  opts = {
    default_mappings = false,
  },
  config = function(opts)
    require('git-conflict').setup(opts)

    vim.keymap.set('n', '<leader>co', '<cmd>GitConflictChooseOurs<CR>')
    vim.keymap.set('n', '<leader>ct', '<cmd>GitConflictChooseTheirs<CR>')
    vim.keymap.set('n', '<leader>c2', '<cmd>GitConflictChooseBoth<CR>')
    vim.keymap.set('n', '<leader>c0', '<cmd>GitConflictChooseNone<CR>')
    vim.keymap.set('n', '[x', '<cmd>GitConflictNextConflict<CR>')
    vim.keymap.set('n', ']x', '<cmd>GitConflictPrevConflict<CR>')
  end,
}
