local default_id_func = function(title)
  local date_str = os.date '%Y%m%d'
  local suffix = ''
  if title ~= nil then
    return title
  else
    for _ = 1, 4 do
      suffix = suffix .. string.char(math.random(97, 122))
    end
  end
  return date_str .. '_' .. suffix
end

return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  lazy = true,
  event = {
    'BufReadPre ' .. vim.fn.expand '~' .. '/obsidian-vault/*.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/obsidian-vault/*.md',
    'BufReadPre oil://' .. vim.fn.expand '~' .. '/obsidian-vault/',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,

    notes_subdir = 'personal/raw',
    new_notes_location = 'notes_subdir',

    link = {
      style = 'wiki',
      format = 'shortest',
      auto_update = false,
    },

    workspaces = {
      {
        name = 'personal',
        path = '~/obsidian-vault/',
      },
    },
    log_level = vim.log.levels.INFO,
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      local date_str = os.date '%Y-%m-%d'
      local suffix = ''
      if title ~= nil then
        return title
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(97, 122))
        end
      end
      return date_str .. '_' .. suffix
    end,
    note_path_func = function(spec)
      local path = spec.dir / tostring(spec.id)
      return path
    end,
    open_notes_in = 'current',

    frontmatter = {
      enabled = true,
      sort = { 'id', 'aliases', 'tags' },
    },

    templates = {
      folder = 'templates/',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
      substitutions = {
        yesterday = function()
          return string(os.date('%Y-%m-%d', os.time() - 86400))
        end,
        tomorrow = function()
          return string(os.date('%Y-%m-%d', os.time() + 86400))
        end,
      },

      customizations = {
        ['Index'] = {
          notes_subdir = 'personal/main',
          note_id_func = default_id_func,
        },
        ['Evergreen'] = {
          notes_subdir = 'personal/main',
          note_id_func = default_id_func,
        },
        ['Learning'] = {
          notes_subdir = 'personal/learning',
          note_id_func = default_id_func,
        },
        ['Guide'] = {
          notes_subdir = 'personal/guide',
          note_id_func = default_id_func,
        },
        ['Work'] = {
          notes_subdir = 'work/work',
          note_id_func = default_id_func,
        },
        ['Ticket'] = {
          notes_subdir = 'work/tickets',
          note_id_func = default_id_func,
        },
        ['Ticket Defect With Merge'] = {
          notes_subdir = 'work/tickets',
          note_id_func = default_id_func,
        },
        ['Ticket With Merge'] = {
          notes_subdir = 'work/tickets',
          note_id_func = default_id_func,
        },
        ['Ticket With Refinement'] = {
          notes_subdir = 'work/tickets',
          note_id_func = default_id_func,
        },
        ['Raw'] = {
          notes_subdir = 'personal/raw',
          note_id_func = function(title)
            local date_str = os.date '%Y-%m-%d'
            local suffix = ''
            if title ~= nil then
              suffix = title:gsub('%s+', '-'):gsub('[^%w%-]', ''):gsub('-+', '-'):gsub('^-', ''):gsub('-$', ''):lower()
            else
              for _ = 1, 4 do
                suffix = suffix .. string.char(math.random(97, 122))
              end
            end
            return date_str .. '_' .. suffix
          end,
        },
        ['Log'] = {
          notes_subdir = 'personal/log',
          note_id_func = function(title)
            local date_str = os.date '%Y-%m-%d %H-%M'
            local suffix = ''
            if title ~= nil then
              suffix = title:gsub('%s+', '-'):gsub('[^%w%-]', ''):gsub('-+', '-'):gsub('^-', ''):gsub('-$', ''):lower()
            else
              for _ = 1, 4 do
                suffix = suffix .. string.char(math.random(97, 122))
              end
            end
            return date_str .. '_' .. suffix
          end,
        },
      },
    },

    backlinks = {
      parse_headers = true,
    },

    completion = (function()
      return {
        min_chars = 2,
        match_case = true,
        create_new = true,
      }
    end)(),

    picker = {
      -- TODO: one day change to 'snacks.pick'
      name = 'telescope.nvim',
      note_mappings = {
        new = '<C-x>',
        insert_link = '<C-l>',
      },
      tag_mappings = {
        tag_note = '<C-x>',
        insert_tag = '<C-l>',
      },
    },

    search = {
      sort_by = 'modified',
      sort_reversed = true,
      max_lines = 1000,
    },

    daily_notes = {
      folder = 'daily/',
      date_format = '%Y-%m-%d',
      alias_format = '%B %-d, %Y',
      default_tags = { 'daily' },
      workdays_only = false,
      template = 'Daily.md',
    },

    ui = {
      enabled = true,
      enable = true,
      ignore_conceal_warn = false,
      update_debounce = 200,
      max_file_length = 5000,
      bullets = { char = '•', hl_group = 'ObsidianBullet' },
      external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
      reference_text = { hl_group = 'ObsidianRefText' },
      highlight_text = { hl_group = 'ObsidianHighlightText' },
      tags = { hl_group = 'ObsidianTag' },
      block_ids = { hl_group = 'ObsidianBlockID' },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = '#f78c6c' },
        ObsidianDone = { bold = true, fg = '#89ddff' },
        ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
        ObsidianTilde = { bold = true, fg = '#ff5370' },
        ObsidianImportant = { bold = true, fg = '#d73128' },
        ObsidianBullet = { bold = true, fg = '#89ddff' },
        ObsidianRefText = { underline = true, fg = '#c792ea' },
        ObsidianExtLinkIcon = { fg = '#c792ea' },
        ObsidianTag = { italic = true, fg = '#89ddff' },
        ObsidianBlockID = { italic = true, fg = '#89ddff' },
        ObsidianHighlightText = { bg = '#75662e' },
      },
    },

    attachments = {
      folder = 'files',
      -- img_text_func = require('obsidian.builtin').img_text_func,
      img_name_func = function()
        return string.format('Pasted image %s', os.date '%Y%m%d%H%M%S')
      end,
      confirm_img_paste = true,
    },

    callbacks = {},

    footer = {
      enabled = true,
      format = '{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars',
      hl_group = 'Comment',
      separator = string.rep('-', 80),
    },

    open = {
      use_advanced_uri = false,
      func = vim.ui.open,
    },

    checkbox = {
      enabled = true,
      create_new = false,
      order = { ' ', 'x' },
    },

    comment = {
      enabled = false,
    },
  },

  config = function(_, opts)
    local obsidian = require 'obsidian'

    obsidian.setup(opts)

    vim.keymap.set('n', '<leader>oc', obsidian.util.toggle_checkbox, { desc = 'Obsidian Toggle Checkbox' })
    vim.keymap.set('n', '<leader>oo', '<cmd>Obsidian open<CR>', { desc = 'Open in Obsidian App' })
    vim.keymap.set('n', '<leader>ob', '<cmd>Obsidian backlinks<CR>', { desc = 'Show Obsidian Backlinks' })
    vim.keymap.set('n', '<leader>ol', '<cmd>Obsidian links<CR>', { desc = 'Show Obsidian Links' })
    vim.keymap.set('n', '<leader>on', '<cmd>Obsidian new_from_template<CR>', { desc = 'Create New Note' })
    vim.keymap.set('n', '<leader>os', '<cmd>Obsidian search<CR>', { desc = 'Search Obsidian' })
    vim.keymap.set('n', '<leader>oq', '<cmd>Obsidian quick_switch<CR>', { desc = 'Quick Switch' })
    vim.keymap.set('n', '<leader>op', '<cmd>Obsidian paste_img<CR>', { desc = 'Paste Image' })
    vim.keymap.set('n', '<leader>od', '<cmd>Obsidian dailies<CR>', { desc = 'Show Obsidian Dailies' })
    vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian template<CR>', { desc = 'Insert Obsidian Templates' })
    vim.keymap.set('n', '<leader>om', '<cmd>Obsidian tags<CR>', { desc = 'Obsidian Tags' })
  end,
}
