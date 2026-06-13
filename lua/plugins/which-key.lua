return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup()

    -- Document existing key chains
    require('which-key').add {
      { '<leader>c', group = '[B]uffer' },
      { '<leader>c', group = '[C]ode' },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>h', group = 'Git [H]unk' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>h', desc = 'Git [H]unk', mode = 'v' },
      { '<leader>g', desc = '[G]it' },
      { '<leader>m', desc = '[M]arkdown' },
      { '<leader>p', desc = '[P]roject' },
      { '<leader>x', desc = 'Trouble' },
    }
  end,
}
