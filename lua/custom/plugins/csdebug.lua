return {
  'nicholasmata/nvim-dap-cs',
  ft = { 'cs', 'razor' },
  dependencies = { 'mfussenegger/nvim-dap' },
  config = function()
    require('dap-cs').setup {
      netcoredbg = {
        -- the path to the executable netcoredbg which will be used for debugging.
        -- by default, this is the "netcoredbg" executable on your PATH.
        path = vim.fn.expand '~/.local/share/nvim/mason/bin/netcoredbg',
      },
    }
  end,
}
