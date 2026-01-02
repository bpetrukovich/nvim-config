return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_vscode').lazy_load {
              paths = { vim.fn.stdpath 'config' .. '/snippets' },
            }
          end,
        },
      },
      opts = {},
    },
    -- 'Kaiser-Yang/blink-cmp-avante',
    -- 'Exafunction/windsurf.nvim',
    'folke/lazydev.nvim',
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'easy-dotnet', 'lazydev' }, -- 'avante', 'codeium'
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        -- codeium = {
        --   name = 'Codeium',
        --   module = 'codeium.blink',
        --   async = true,
        --   enabled = function()
        --     return vim.bo.filetype ~= 'oil'
        --   end,
        -- },
        -- avante = {
        --   module = 'blink-cmp-avante',
        --   name = 'Avante',
        --   opts = {},
        -- },
        ['easy-dotnet'] = {
          name = 'easy-dotnet',
          enabled = true,
          module = 'easy-dotnet.completion.blink',
          score_offset = 10000,
          async = true,
        },
      },
    },

    snippets = { preset = 'luasnip' },

    fuzzy = { implementation = 'prefer_rust_with_warning' },

    signature = { enabled = true },
  },
}
