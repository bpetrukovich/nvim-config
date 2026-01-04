return {
  'seblj/roslyn.nvim',
  ft = { 'cs', 'razor' },
  opts = { filewatching = 'roslyn' },
  config = function()
    local handles = {}

    vim.api.nvim_create_autocmd('User', {
      pattern = 'RoslynRestoreProgress',
      callback = function(ev)
        local token = ev.data.params[1]
        local handle = handles[token]
        if handle then
          handle:report {
            title = ev.data.params[2].state,
            message = ev.data.params[2].message,
          }
        else
          handles[token] = require('fidget.progress').handle.create {
            title = ev.data.params[2].state,
            message = ev.data.params[2].message,
            lsp_client = {
              name = 'roslyn',
            },
          }
        end
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'RoslynRestoreResult',
      callback = function(ev)
        local handle = handles[ev.data.token]
        handles[ev.data.token] = nil

        if handle then
          handle.message = ev.data.err and ev.data.err.message or 'Restore completed'
          handle:finish()
        end
      end,
    })

    vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
      pattern = '*',
      callback = function()
        local clients = vim.lsp.get_clients { name = 'roslyn' }
        for _, client in ipairs(clients) do
          local buffers = vim.lsp.get_buffers_by_client_id(client.id)
          for _, buf in ipairs(buffers) do
            client:request('textDocument/diagnostic', {
              textDocument = vim.lsp.util.make_text_document_params(buf),
            })
          end
        end
      end,
    })

    local cmd = {
      'roslyn',
      '--stdio',
      '--logLevel=Information',
      '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
      '--extension',
    }

    vim.lsp.config('roslyn', {
      cmd = cmd,
      settings = {
        ['csharp|inlay_hints'] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_indexer_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = true,
          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ['csharp|code_lens'] = {
          dotnet_enable_references_code_lens = true,
        },
        ['csharp|formatting'] = {
          dotnet_organize_imports_on_format = true,
        },
      },
    })
    vim.lsp.enable 'roslyn'
  end,
  -- init = function()
  --   -- We add the Razor file types before the plugin loads.
  --   vim.filetype.add {
  --     extension = {
  --       razor = 'razor',
  --       cshtml = 'razor',
  --     },
  --   }
  -- end,
  --
}
