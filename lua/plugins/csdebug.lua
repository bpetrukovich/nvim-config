return {
  'nicholasmata/nvim-dap-cs',
  ft = { 'cs', 'razor' },
  dependencies = { 'mfussenegger/nvim-dap' },
  config = function()
    require('dap-cs').setup {
      netcoredbg = {
        path = vim.fn.expand '~/.local/share/nvim/mason/bin/netcoredbg',
      },
    }
  end,
}
