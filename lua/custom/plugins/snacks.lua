return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = false },
    words = { enabled = true },
    zen = { enabled = true },
    picker = {
      enabled = true,
      ui_select = true, -- replace vim.ui.select
      sources = {
        files = {
          hidden = true,
        },
      },
      win = {
        input = {
          keys = {
            ['<c-t>'] = {
              'trouble_open',
              mode = { 'n', 'i' },
            },
          },
        },
      },
      actions = {
        trouble_open = function(picker)
          picker:close()
          local sel = picker:selected { fallback = true }
          local items = {}
          for _, item in ipairs(sel) do
            local text = item.text or item.file or ''
            items[#items + 1] = {
              filename = item.file,
              lnum = item.pos and item.pos[1] or 1,
              col = item.pos and item.pos[2] or 1,
              text = text,
            }
          end
          if #items > 0 then
            vim.fn.setqflist(items)
            vim.cmd 'Trouble qflist open'
          end
        end,
      },
    },
  },
  keys = {
    -- Zen mode
    {
      '<leader>z',
      function()
        Snacks.zen()
      end,
      desc = 'Toggle Zen Mode',
    },
    {
      '<leader>Z',
      function()
        Snacks.zen.zoom()
      end,
      desc = 'Toggle Zoom',
    },

    -- Scratch
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },

    -- Notifications
    {
      '<leader>nh',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
    {
      '<leader>nd',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
    },

    -- Buffer
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
    },

    -- Words navigation
    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
    },

    -- ============ PICKER KEYMAPS (matching your Telescope setup) ============

    -- Search files
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>si',
      function()
        Snacks.picker.files { hidden = true, ignored = true }
      end,
      desc = '[S]earch [I]gnored files',
    },
    {
      '<leader>sn',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },

    -- Search text
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[S]earch by [G]rep',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = '[S]earch current [W]ord',
      mode = { 'n', 'x' },
    },
    {
      '<leader>/',
      function()
        Snacks.picker.lines()
      end,
      desc = '[/] Search in current buffer',
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = '[S]earch [/] in Open Files',
    },

    -- Grep with test exclusions/inclusions
    {
      '<leader>sy',
      function()
        Snacks.picker.grep {
          exclude = { '*.spec.*', 'test/mocks/*', 'test/stubs/*', 'tests/*' },
        }
      end,
      desc = '[S]earch Grep (tests excluded)',
    },
    {
      '<leader>st',
      function()
        Snacks.picker.grep {
          glob = { '*.spec.*', 'test/mocks/**', 'test/stubs/**', 'tests/**' },
        }
      end,
      desc = '[S]earch Grep [T]ests only',
    },

    -- Buffers & Recent
    {
      '<leader>bb',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Find existing [B]uffers',
    },
    {
      '<leader>s.',
      function()
        Snacks.picker.recent()
      end,
      desc = '[S]earch Recent Files',
    },

    -- Help & Info
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.pickers()
      end,
      desc = '[S]earch [S]elect Picker',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },

    -- Git
    {
      '<leader>sb',
      function()
        Snacks.picker.git_branches()
      end,
      desc = '[S]earch [B]ranches',
    },

    -- LSP (these will work when buffer has LSP attached)
    {
      '<leader>sl',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = '[S]ymbols [L]ist (document)',
    }, -- TODO: very bad
    {
      '<leader>ws',
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = '[W]orkspace [S]ymbols',
    },
  },
}
