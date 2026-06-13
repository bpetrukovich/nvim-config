return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettierd', 'prettier' },
      -- htmlangular = { 'prettierd', 'prettier' },
      -- htmlangular = { 'htmlhint' },
      typescript = { 'prettierd', 'prettier' },
      ejs = { 'prettierd', 'prettier' },
      css = { 'stylelint' },
      scss = { 'stylelint' },
      json = { 'prettierd', 'prettier' },
      yaml = { 'prettierd', 'prettier' },
      typescriptreact = { 'prettierd', 'prettier' },
      javascriptreact = { 'prettierd', 'prettier' },
      markdown = { 'markdownlint' },
      rust = { 'rustfmt' },
      go = { 'gofmt' },
      -- c = { 'clang-format' },
      -- cpp = { 'clang-format' },
      -- cs = { 'roslyn' },
    },
  },
}
