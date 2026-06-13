return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        css = { 'stylelint' },
        scss = { 'stylelint' },
        sass = { 'stylelint' },
      }
      lint.linters.htmlhint.args = {
        '--config',
        vim.fn.getcwd() .. '/node_modules/@pmi/htmlhint-config/htmlhintrc.json',
        '--format',
        'json',
      }

      vim.keymap.set('n', '<leader>j', function()
        require('lint').try_lint()
      end, { desc = 'Trigger linting for current file' })
    end,
  },
}
