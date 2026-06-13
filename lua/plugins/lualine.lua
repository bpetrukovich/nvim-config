return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local lualine = require 'lualine'

    -- Color table for highlights (Kanagawa Dragon theme)
    -- stylua: ignore
    local colors = {
      bg       = '#282727',   -- dragon_black_3
      fg       = '#c5c9c5',   -- dragon_white
      yellow   = '#c4b28a',   -- dragon_yellow (harpoon highlight)
      cyan     = '#8ea4a2',   -- dragon_aqua
      darkblue = '#1D1C19',   -- dragon_black_2
      green    = '#87a987',   -- dragon_green
      orange   = '#b6927b',   -- dragon_orange
      violet   = '#8992a7',   -- dragon_violet
      magenta  = '#a292a3',   -- dragon_pink
      blue     = '#658594',   -- dragon_blue
      red      = '#c4746e',   -- dragon_red
      ash      = '#737c73',   -- dragon_ash (harpoon normal)
      teal     = '#949fb5',   -- dragon_teal
      gray     = '#625e5a',   -- dragon_black_6
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand '%:t') ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand '%:p:h'
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
    }

    local function get_harpoon_indicator(harpoon_entry)
      return ' ' .. vim.fn.fnamemodify(harpoon_entry.value, ':t') .. ' '
    end

    -- Config
    local config = {
      options = {
        -- Disable sections and component separators
        component_separators = '',
        section_separators = '',
        theme = {
          -- We are going to use lualine_c an lualine_x as left and
          -- right section. Both are highlighted by c theme .  So we
          -- are just setting default looks o statusline
          normal = { c = { fg = colors.fg, bg = colors.bg } },
          inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
      },
      sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {
          {
            'filename',
            path = 1,
            color = { fg = colors.fg, gui = 'bold' },
          },
        },
        lualine_x = {},
      },
    }

    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x at right section
    local function ins_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    ins_left {
      'location',
      color = { fg = colors.bg, bg = colors.orange, gui = 'bold' },
    }

    ins_left {
      -- filesize component
      'filesize',
      cond = conditions.buffer_not_empty,
      color = { fg = colors.bg, bg = colors.violet },
    }

    ins_left {
      'branch',
      color = { fg = colors.red, gui = 'bold' },
    }

    ins_left {
      'filetype',
      color = { fg = colors.blue, gui = 'bold' },
    }

    ins_left {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      symbols = { error = ' ', warn = ' ', info = ' ' },
      diagnostics_color = {
        error = { fg = colors.red },
        warn = { fg = colors.orange },
        info = { fg = colors.teal },
      },
    }

    -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater then 2
    ins_left {
      function()
        return '%='
      end,
    }

    ins_left {
      function()
        if vim.bo.filetype == 'oil' then
          local dir = require('oil').get_current_dir()
          if not dir then
            return ''
          end
          return vim.fn.fnamemodify(dir, ':.')
        end

        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname == '' then
          return ''
        end

        if bufname:match '://' then
          return bufname
        end

        return vim.fn.fnamemodify(bufname, ':t')
      end,
      color = { fg = colors.fg, gui = 'bold' },
    }

    ins_right {
      'harpoon2',
      icon = false,
      indicators = {
        get_harpoon_indicator,
        get_harpoon_indicator,
        get_harpoon_indicator,
        get_harpoon_indicator,
      },
      active_indicators = {
        get_harpoon_indicator,
        get_harpoon_indicator,
        get_harpoon_indicator,
        get_harpoon_indicator,
      },
      color = { fg = colors.darkblue, bg = colors.ash },
      color_active = { fg = colors.darkblue, bg = colors.yellow, gui = 'bold' },
      _separator = '',
      no_harpoon = 'Harpoon not loaded',
      padding = { left = 0, right = 0 },
      cond = conditions.hide_in_width,
    }

    -- Now don't forget to initialize lualine
    lualine.setup(config)
  end,
}

-- ins_left {
--   function()
--     return '▊'
--   end,
--   color = { fg = colors.blue }, -- Sets highlighting of component
--   padding = { left = 0, right = 1 }, -- We don't need space before this
-- }

-- ins_left {
--   -- mode component
--   function()
--     return ''
--   end,
--   color = function()
--     -- auto change color according to neovims mode
--     local mode_color = {
--       n = colors.red,
--       i = colors.green,
--       v = colors.blue,
--       [''] = colors.blue,
--       V = colors.blue,
--       c = colors.magenta,
--       no = colors.red,
--       s = colors.orange,
--       S = colors.orange,
--       [''] = colors.orange,
--       ic = colors.yellow,
--       R = colors.violet,
--       Rv = colors.violet,
--       cv = colors.red,
--       ce = colors.red,
--       r = colors.cyan,
--       rm = colors.cyan,
--       ['r?'] = colors.cyan,
--       ['!'] = colors.red,
--       t = colors.red,
--     }
--     return { fg = mode_color[vim.fn.mode()] }
--   end,
--   padding = { right = 1 },
-- }
-- ins_left {
--   -- Lsp server name .
--   function()
--     local msg = 'No Active Lsp'
--     local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
--     local clients = vim.lsp.get_clients()
--     if next(clients) == nil then
--       return msg
--     end
--     for _, client in ipairs(clients) do
--       local filetypes = client.config.filetypes
--       if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
--         return client.name
--       end
--     end
--     return msg
--   end,
--   icon = ' LSP:',
--   color = { fg = colors.fg, gui = 'bold' },
-- }

-- Add components to right sections
-- ins_right {
--   'o:encoding', -- option component same as &encoding in viml
--   fmt = string.upper, -- I'm not sure why it's upper case either ;)
--   cond = conditions.hide_in_width,
--   color = { fg = colors.green, gui = 'bold' },
-- }

-- ins_right {
--   'fileformat',
--   fmt = string.upper,
--   icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
--   color = { fg = colors.green, gui = 'bold' },
-- }
--
-- ins_right {
--   function()
--     return '▊'
--   end,
--   color = { fg = colors.blue },
--   padding = { left = 1 },
-- }
