return {
  'mbbill/undotree',
  config = function()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle [U]ndotree' })
  end,
}

-- return {
--   'rest-nvim/rest.nvim',
--   dependencies = {
--     'nvim-neotest/nvim-nio',
--     'j-hui/fidget.nvim',
--   },
--   config = function()
--     vim.g.rest_nvim = {
--       -- Open request results in a horizontal split
--       result_split_horizontal = false,
--       -- Keep the http file buffer above|left when split horizontal|vertical
--       result_split_in_place = false,
--       -- Skip SSL verification, useful for unknown certificates
--       skip_ssl_verification = false,
--       -- Encode URL before making request
--       encode_url = true,
--       -- Highlight request on run
--       highlight = {
--         enabled = true,
--         timeout = 150,
--       },
--       result = {
--         -- toggle showing URL, HTTP info, headers
--         show_url = true,
--         show_http_info = true,
--         show_headers = true,
--       },
--     }
--   end,
-- }
