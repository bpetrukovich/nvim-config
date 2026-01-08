return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "nvim-mini/mini.icons" },
  config = function()
    vim.keymap.set('n', '<leader>ff', function()
      require('fzf-lua').live_grep()
    end, { desc = 'Grep fzf' })

    vim.keymap.set('n', '<leader>fr', function()
      require('fzf-lua').resume()
    end, { desc = 'fzf Resume' })

    vim.keymap.set('n', '<leader>ft', function()
      require('fzf-lua').filetypes()
    end, { desc = 'fzf Change Filetype' })
  end,
}
