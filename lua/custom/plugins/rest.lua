return {
  'mistweaverco/kulala.nvim',
  opts = {},
  config = function()
    local kulala = require 'kulala'

    vim.keymap.set('n', '<leader>mr', kulala.run, { desc = 'Run the current request' })
    vim.keymap.set('n', '<leader>ma', kulala.run_all, { desc = 'Run all requests in the current buffer' })
    vim.keymap.set('n', '<leader>mi', kulala.inspect, { desc = 'inspect the current request' })
    vim.keymap.set('n', '<leader>ms', kulala.show_stats, { desc = 'show the statistics of the last run request' })
    vim.keymap.set('n', '<leader>mp', kulala.scratchpad, { desc = 'open the scratchpad' })
    vim.keymap.set('n', '<leader>mc', kulala.copy, { desc = 'copy the current request as cURL command' })
    vim.keymap.set('n', '<leader>mq', kulala.close, { desc = 'close the kulala window and also the current buffer' })
    vim.keymap.set('n', '<leader>mjp', kulala.jump_prev, { desc = 'jump to the previous request' })
    vim.keymap.set('n', '<leader>mjn', kulala.jump_next, { desc = 'jump to the next request' })
    vim.keymap.set('n', '<leader>ml', kulala.from_curl, { desc = 'cURL command from clipboard -> HTTP spec' })
    vim.keymap.set('n', '<leader>mt', kulala.toggle_view, { desc = 'toggle between the body and headers view of the last run request' })
  end,
}
