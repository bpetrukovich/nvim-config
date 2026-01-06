return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  opts = {
    filetype_exclude = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'mason' },
  },
  config = function(_, opts)
    vim.opt.foldcolumn = '0'
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = true

    vim.opt.fillchars = {
      eob = ' ',
      fold = ' ',
      foldopen = '',
      foldclose = '',
      foldsep = ' ',
    }

    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('local_detach_ufo', { clear = true }),
      pattern = opts.filetype_exclude,
      callback = function()
        require('ufo').detach()
      end,
    })

    require('ufo').setup(opts)
  end,
}
