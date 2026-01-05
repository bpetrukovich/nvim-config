return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "nvim-mini/mini.icons" },
  config = function()
    vim.keymap.set('n', '<leader>sg', function()
      require('fzf-lua').live_grep()
    end, { desc = 'Grep (fzf)' })
  end,
}
