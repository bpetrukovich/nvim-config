return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'kanagawa-dragon'

      -- Remove italic font for comments
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
