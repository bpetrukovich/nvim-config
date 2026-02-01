-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  'mfussenegger/nvim-dap',
  -- event = 'VeryLazy',
  lazy = true,
  dependencies = {
    -- Creates a beautiful debugger UI
    -- 'rcarriga/nvim-dap-ui',
    'igorlfs/nvim-dap-view',

    -- Required dependency for nvim-dap-ui
    -- 'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
    -- 'microsoft/vscode-js-debug',
    'mxsdev/nvim-dap-vscode-js',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-telescope/telescope-dap.nvim',
    'Weissle/persistent-breakpoints.nvim',
  },
  config = function()
    local dap = require 'dap'
    -- local dapui = require 'dapui'
    local dapui = require 'dap-view'

    dapui.setup {
      windows = {
        terminal = {
          -- Use the actual names for the adapters you want to hide
          hide = { 'go', 'coreclr' }, -- `go` is known to not use the terminal.
        },
      },
    }

    require('telescope').load_extension 'dap'
    require('nvim-dap-virtual-text').setup {}
    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve',
        'js-debug-adapter',
        'netcoredbg',
      },
    }

    require('persistent-breakpoints').setup {
      load_breakpoints_event = { 'BufReadPost' },
      always_reload = true,
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<S-F11>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>dd', '<cmd>DapDisconnect<CR>', { desc = 'Debug: Disconnect' })
    vim.keymap.set('n', '<leader>dT', '<cmd>DapTerminate<CR>', { desc = 'Debug: Terminate' })
    vim.keymap.set('n', '<leader>do', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<F4>', '<cmd>PBToggleBreakpoint<CR>', { desc = 'Debug: Toggle Persistent Breakpoint' })
    vim.keymap.set('n', '<leader>dl', '<cmd>Telescope dap list_breakpoints<CR>', { desc = 'Debug: List Breakpoints' })
    vim.keymap.set('n', '<leader>df', '<cmd>Telescope dap frames<CR>', { desc = 'Debug: Show Stack' })
    vim.keymap.set('n', '<leader>ds', function()
      dapui.show_view 'scopes'
    end, { desc = 'Debug: Show Scopes' })
    vim.keymap.set('n', '<leader>dw', function()
      dapui.show_view 'watches'
    end, { desc = 'Debug: Show Watches' })
    vim.keymap.set('n', '<leader>de', function()
      dapui.show_view 'exceptions'
    end, { desc = 'Debug: Show Exceptions' })
    vim.keymap.set('n', '<leader>dr', function()
      dapui.show_view 'repl'
    end, { desc = 'Debug: Show REPL' })
    vim.keymap.set('n', '<leader>dt', function()
      dapui.show_view 'threads'
    end, { desc = 'Debug: Show Threads' })
    vim.keymap.set('n', '<leader>db', function()
      dapui.show_view 'breakpoints'
    end, { desc = 'Debug: Show breakpoints' })

    vim.keymap.set('n', '<Leader>dc', function()
      vim.ui.input({ prompt = 'Condition (exp): ' }, function(cond)
        if not cond then
          return
        end

        vim.ui.input({ prompt = 'Hit condition (num): ' }, function(hit)
          if not hit then
            return
          end

          vim.ui.input({ prompt = 'Log message: ' }, function(log)
            if not log then
              return
            end

            local c = cond ~= '' and cond or nil
            local h = hit ~= '' and hit or nil
            local l = log ~= '' and log or nil

            dap.set_breakpoint(c, h, l)
          end)
        end)
      end)
    end, { desc = 'Dap: Smart Breakpoint' })

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    -- vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    -- dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    -- dap.listeners.before.event_exited['dapui_config'] = dapui.close

    dap.listeners.before.attach['dap-view-config'] = function()
      dapui.open()
    end
    dap.listeners.before.launch['dap-view-config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dap-view-config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dap-view-config'] = function()
      dapui.close()
    end

    -- require('dap-vscode-js').setup {
    --   -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    --   -- debugger_path = '~/.config/nvim/dbg/js-debug/', -- Path to vscode-js-debug installation.
    --   -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    --   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
    --   -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
    --   -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
    --   -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
    -- }

    for _, adapterType in ipairs { 'node', 'chrome', 'msedge' } do
      local pwaType = 'pwa-' .. adapterType

      dap.adapters[pwaType] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = {
            vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
            '${port}',
          },
        },
      }
      -- this allow us to handle launch.json configurations
      -- which specify type as "node" or "chrome" or "msedge"
      dap.adapters[adapterType] = function(cb, config)
        local nativeAdapter = dap.adapters[pwaType]

        config.type = pwaType

        if type(nativeAdapter) == 'function' then
          nativeAdapter(cb, config)
        else
          cb(nativeAdapter)
        end
      end
    end

    local enter_launch_url = function()
      local co = coroutine.running()
      return coroutine.create(function()
        vim.ui.input({ prompt = 'Enter URL: ', default = 'http://localhost:' }, function(url)
          if url == nil or url == '' then
            return
          else
            coroutine.resume(co, url)
          end
        end)
      end)
    end

    for _, language in ipairs { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue' } do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file using Node.js (nvim-dap)',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to process using Node.js (nvim-dap)',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
        -- requires ts-node to be installed globally or locally
        -- {
        --   type = 'pwa-node',
        --   request = 'launch',
        --   name = 'Launch file using Node.js with ts-node/register (nvim-dap)',
        --   program = '${file}',
        --   cwd = '${workspaceFolder}',
        --   runtimeArgs = { '-r', 'ts-node/register' },
        -- },
        {
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Launch Chrome (nvim-dap)',
          url = enter_launch_url,
          webRoot = '${workspaceFolder}/public',
          sourceMaps = true,
        },
        {
          type = 'pwa-msedge',
          request = 'launch',
          name = 'Launch Edge (nvim-dap)',
          url = enter_launch_url,
          webRoot = '${workspaceFolder}',
          sourceMaps = true,
        },
        {
          type = 'pwa-chrome',
          request = 'attach',
          name = 'Attach to Angular (9222)',
          url = 'http://localhost:4200', -- URL вашего Angular-приложения
          webRoot = '/home/bpetrukovich/projects/itr/front/PMI_Framework_Admin',
          port = 9222,
          host = '127.0.0.1', -- Важно: только IPv4 (не 'localhost')
          sourceMaps = true,
          trace = true, -- Включить логирование
          runtimeExecutable = '/snap/chromium/current/usr/lib/chromium-browser/chrome', -- Полный путь к Chromium
          runtimeArgs = {
            '--remote-debugging-port=9222',
            '--no-first-run',
            '--no-default-browser-check',
          },
          sourceMapPathOverrides = {
            ['webpack:///./*'] = '${webRoot}/*',
            ['webpack:///src/*'] = '${webRoot}/src/*',
            ['webpack:///*'] = '*', -- Важно для Angular!
            ['webpack:///./~/*'] = '${webRoot}/node_modules/*', -- Для node_modules
          },
          skipFiles = { '<node_internals>/**' }, -- Пропустить внутренние файлы Node
        },
        {
          type = 'pwa-chrome',
          request = 'launch', -- Важно: используем launch вместо attach
          name = 'Launch Angular (4200)',
          url = 'http://localhost:4200', -- URL вашего Angular-приложения
          webRoot = '${workspaceFolder}',
          sourceMaps = true,
          trace = true, -- Для детальных логов
          runtimeExecutable = '/snap/chromium/current/usr/lib/chromium-browser/chrome',
          runtimeArgs = {
            '--remote-debugging-port=9222', -- Можно оставить или удалить (для launch не всегда нужно)
            '--no-first-run',
            '--no-default-browser-check',
            '--auto-open-devtools-for-tabs', -- Автоматически открыть DevTools
          },
          sourceMapPathOverrides = {
            ['webpack:///./*'] = '${webRoot}/*',
            ['webpack:///src/*'] = '${webRoot}/src/*',
            ['webpack:///*'] = '*', -- Важно для Angular!
          },
        },
        {
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Launch Angular in Windows Chrome',
          url = 'http://localhost:4200', -- URL вашего Angular-приложения
          webRoot = '${workspaceFolder}',
          sourceMaps = true,
          trace = true, -- Для логов
          runtimeExecutable = '/mnt/c/Program\\ Files/Google/Chrome/Application/chrome.exe', -- Путь к Chrome в Windows
          runtimeArgs = {
            '--remote-debugging-port=9222',
            '--no-first-run',
            '--no-default-browser-check',
            '--auto-open-devtools-for-tabs', -- Автоматически открыть DevTools
          },
          host = '10.255.255.254', -- Магический хост для WSL2 → Windows
          port = 9222, -- Порт для remote debugging
          sourceMapPathOverrides = {
            ['webpack:///./*'] = '${webRoot}/*',
            ['webpack:///src/*'] = '${webRoot}/src/*',
            ['webpack:///*'] = '*',
          },
        },
      }
    end
  end,
}

-- Install golang specific config
-- require('dap-go').setup {
--   delve = {
--     -- On Windows delve must be run attached or it crashes.
--     -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
--     detached = vim.fn.has 'win32' == 0,
--   },
-- }

-- dap.adapters.coreclr = {
--   type = 'executable',
--   command = '/home/bpetrukovich/.local/share/nvim/mason/bin/netcoredbg',
--   args = { '--interpreter=vscode' },
-- }
--
-- dap.configurations.cs = {
--   {
--     env = {
--       ASPNETCORE_ENVIRONMENT = 'Development',
--     },
--     type = 'coreclr',
--     name = 'launch - netcoredbg',
--     request = 'launch',
--     program = function()
--       return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/src/', 'file')
--     end,
--   },
-- }

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
-- dapui.setup {
--   -- Set icons to characters that are more likely to work in every terminal.
--   --    Feel free to remove or use ones that you like more! :)
--   --    Don't feel like these are good choices.
--   icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
--   controls = {
--     enabled = true,
--     element = 'repl',
--     icons = {
--       pause = '⏸',
--       play = '▶',
--       step_into = '⏎',
--       step_over = '⏭',
--       step_out = '⏮',
--       step_back = 'b',
--       run_last = '▶▶',
--       terminate = '⏹',
--       disconnect = '⏏',
--     },
--   },
--   element_mappings = {},
--   expand_lines = true,
--   floating = {
--     border = 'single',
--     mappings = {
--       close = { 'q', '<Esc>' },
--     },
--   },
--   force_buffers = true,
--   layouts = {
--     {
--       elements = {
--         {
--           id = 'scopes',
--           size = 0.25,
--         },
--         {
--           id = 'breakpoints',
--           size = 0.25,
--         },
--         {
--           id = 'stacks',
--           size = 0.25,
--         },
--         {
--           id = 'watches',
--           size = 0.25,
--         },
--       },
--       position = 'left',
--       size = 40,
--     },
--     {
--       elements = { {
--         id = 'repl',
--         size = 0.5,
--       }, {
--         id = 'console',
--         size = 0.5,
--       } },
--       position = 'bottom',
--       size = 10,
--     },
--   },
--   mappings = {
--     edit = 'e',
--     expand = { '<CR>', '<2-LeftMouse>' },
--     open = 'o',
--     remove = 'd',
--     repl = 'r',
--     toggle = 't',
--   },
--   render = {
--     indent = 1,
--     max_value_lines = 100,
--   },
-- }
