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
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { cs = true, c = true, cpp = true, ts = true, js = true, htmlangular = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 1500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettierd', 'prettier' },
      htmlangular = { 'prettierd', 'prettier' },
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
