---@type obsidian.config.Internal
local o = {
  -- TODO: remove these in 4.0.0
  legacy_commands = true,
  note_frontmatter_func = require('obsidian.builtin').frontmatter,
  disable_frontmatter = false,
  ---@class obsidian.config.StatuslineOpts
  ---
  ---@field format? string
  ---@field enabled? boolean
  statusline = {
    format = '{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars',
    enabled = true,
  },

  -- TODO:: replace with more general options before 4.0.0
  follow_url_func = vim.ui.open,
  follow_img_func = vim.ui.open,
  notes_subdir = nil,
  new_notes_location = 'current_dir',

  workspaces = {},
  log_level = vim.log.levels.INFO,
  note_id_func = require('obsidian.builtin').zettel_id,
  note_path_func = function(spec)
    local path = spec.dir / tostring(spec.id)
    return path
  end,
  wiki_link_func = require('obsidian.builtin').wiki_link_id_prefix,
  markdown_link_func = require('obsidian.builtin').markdown_link,
  preferred_link_style = 'wiki',
  open_notes_in = 'current',

  ---@class obsidian.config.FrontmatterOpts
  ---
  --- Whether to enable frontmatter, boolean for global on/off, or a function that takes filename and returns boolean.
  ---@field enabled? (fun(fname: string?): boolean)|boolean
  ---
  --- Function to turn Note attributes into frontmatter.
  ---@field func? fun(note: obsidian.Note): table<string, any>
  --- Function that is passed to table.sort to sort the properties, or a fixed order of properties.
  ---
  --- List of string that sorts frontmatter properties, or a function that compares two values, set to vim.NIL/false to do no sorting
  ---@field sort? string[] | (fun(a: any, b: any): boolean) | vim.NIL | boolean
  frontmatter = {
    enabled = true,
    func = require('obsidian.builtin').frontmatter,
    sort = { 'id', 'aliases', 'tags' },
  },

  ---@class obsidian.config.TemplateOpts
  ---
  ---@field folder string|obsidian.Path|?
  ---@field date_format string|?
  ---@field time_format string|?
  --- A map for custom variables, the key should be the variable and the value a function.
  --- Functions are called with obsidian.TemplateContext objects as their sole parameter.
  --- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#substitutions
  ---@field substitutions table<string, (fun(ctx: obsidian.TemplateContext):string)|(fun(): string)|string>|?
  ---@field customizations table<string, obsidian.config.CustomTemplateOpts>|?
  templates = {
    folder = nil,
    date_format = nil,
    time_format = nil,
    substitutions = {},

    ---@class obsidian.config.CustomTemplateOpts
    ---
    ---@field notes_subdir? string
    ---@field note_id_func? (fun(title: string|?, path: obsidian.Path|?): string)
    customizations = {},
  },

  ---@class obsidian.config.BacklinkOpts
  ---
  ---@field parse_headers boolean
  backlinks = {
    parse_headers = true,
  },

  ---@class obsidian.config.CompletionOpts
  ---
  ---@field nvim_cmp? boolean
  ---@field blink? boolean
  ---@field min_chars? integer
  ---@field match_case? boolean
  ---@field create_new? boolean
  completion = (function()
    local has_nvim_cmp, _ = pcall(require, 'cmp')
    local has_blink = pcall(require, 'blink.cmp')
    return {
      nvim_cmp = has_nvim_cmp and not has_blink,
      blink = has_blink,
      min_chars = 2,
      match_case = true,
      create_new = true,
    }
  end)(),

  ---@class obsidian.config.PickerNoteMappingOpts
  ---
  ---@field new? string
  ---@field insert_link? string

  ---@class obsidian.config.PickerTagMappingOpts
  ---
  ---@field tag_note? string
  ---@field insert_tag? string

  ---@class obsidian.config.PickerOpts
  ---
  ---@field name obsidian.config.Picker|?
  ---@field note_mappings? obsidian.config.PickerNoteMappingOpts
  ---@field tag_mappings? obsidian.config.PickerTagMappingOpts
  picker = {
    name = nil,
    note_mappings = {
      new = '<C-x>',
      insert_link = '<C-l>',
    },
    tag_mappings = {
      tag_note = '<C-x>',
      insert_tag = '<C-l>',
    },
  },

  ---@class obsidian.config.SearchOpts
  ---
  ---@field sort_by string
  ---@field sort_reversed boolean
  ---@field max_lines integer
  search = {
    sort_by = 'modified',
    sort_reversed = true,
    max_lines = 1000,
  },

  ---@class obsidian.config.DailyNotesOpts
  ---
  ---@field folder? string
  ---@field date_format? string
  ---@field alias_format? string
  ---@field template? string
  ---@field default_tags? string[]
  ---@field workdays_only? boolean
  daily_notes = {
    folder = nil,
    date_format = '%Y-%m-%d',
    alias_format = nil,
    default_tags = { 'daily-notes' },
    workdays_only = true,
  },

  ---@class obsidian.config.UICharSpec
  ---@field char string
  ---@field hl_group string

  ---@class obsidian.config.CheckboxSpec : obsidian.config.UICharSpec
  ---@field char string
  ---@field hl_group string

  ---@class obsidian.config.UIStyleSpec
  ---@field hl_group string

  ---@class obsidian.config.UIOpts
  ---
  ---@field enable boolean
  ---@field ignore_conceal_warn boolean
  ---@field update_debounce integer
  ---@field max_file_length integer|?
  ---@field checkboxes table<string, obsidian.config.CheckboxSpec>
  ---@field bullets obsidian.config.UICharSpec|?
  ---@field external_link_icon obsidian.config.UICharSpec
  ---@field reference_text obsidian.config.UIStyleSpec
  ---@field highlight_text obsidian.config.UIStyleSpec
  ---@field tags obsidian.config.UIStyleSpec
  ---@field block_ids obsidian.config.UIStyleSpec
  ---@field hl_groups table<string, table>
  ui = {
    enable = true,
    ignore_conceal_warn = false,
    update_debounce = 200,
    max_file_length = 5000,
    checkboxes = {
      [' '] = { char = '󰄱', hl_group = 'obsidiantodo' },
      ['~'] = { char = '󰰱', hl_group = 'obsidiantilde' },
      ['!'] = { char = '', hl_group = 'obsidianimportant' },
      ['>'] = { char = '', hl_group = 'obsidianrightarrow' },
      ['x'] = { char = '', hl_group = 'obsidiandone' },
    },
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

  ---@class obsidian.config.AttachmentsOpts
  ---
  ---Default folder to save images to, relative to the vault root (/) or current dir (.), see https://github.com/obsidian-nvim/obsidian.nvim/wiki/Images#change-image-save-location
  ---@field folder? string
  ---
  ---Default name for pasted images
  ---@field img_name_func? fun(): string
  ---
  ---Default text to insert for pasted images
  ---@field img_text_func? fun(path: obsidian.Path): string
  ---
  ---Whether to confirm the paste or not. Defaults to true.
  ---@field confirm_img_paste? boolean
  attachments = {
    folder = 'attachments',
    img_text_func = require('obsidian.builtin').img_text_func,
    img_name_func = function()
      return string.format('Pasted image %s', os.date '%Y%m%d%H%M%S')
    end,
    confirm_img_paste = true, -- TODO: move to paste module, paste.confirm
  },

  ---@class obsidian.config.CallbackConfig
  ---
  ---Runs right after setup
  ---@field post_setup? fun()
  ---
  ---Runs when entering a note buffer.
  ---@field enter_note? fun(note: obsidian.Note)
  ---
  ---Runs when leaving a note buffer.
  ---@field leave_note? fun(note: obsidian.Note)
  ---
  ---Runs right before writing a note buffer.
  ---@field pre_write_note? fun(note: obsidian.Note)
  ---
  ---Runs anytime the workspace is set/changed.
  ---@field post_set_workspace? fun(workspace: obsidian.Workspace)
  callbacks = {},

  ---@class obsidian.config.FooterOpts
  ---
  ---@field enabled? boolean
  ---@field format? string
  ---@field hl_group? string
  ---@field separator? string|false Set false to disable separator; set an empty string to insert a blank line separator.
  footer = {
    enabled = true,
    format = '{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars',
    hl_group = 'Comment',
    separator = string.rep('-', 80),
  },

  ---@class obsidian.config.OpenOpts
  ---
  ---Opens the file with current line number
  ---@field use_advanced_uri? boolean
  ---
  ---Function to do the opening, default to vim.ui.open
  ---@field func? fun(uri: string)
  open = {
    use_advanced_uri = false,
    func = vim.ui.open,
  },

  ---@class obsidian.config.CheckboxOpts
  ---
  ---@field enabled? boolean
  ---
  ---Order of checkbox state chars, e.g. { " ", "x" }
  ---@field order? string[]
  ---
  ---Whether to create new checkbox on paragraphs
  ---@field create_new? boolean
  checkbox = {
    enabled = true,
    create_new = true,
    order = { ' ', '~', '!', '>', 'x' },
  },

  ---@class obsidian.config.CommentOpts
  ---@field enabled boolean
  comment = {
    enabled = false,
  },
}

return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',

    -- see above for full list of optional dependencies ☝️
  },
  ---@module 'obsidian'
  ---@type obsidian.config.ClientOpts
  opts = {
    workspaces = {
      {
        name = 'personal',
        -- path = '/mnt/c/Users/b.petrukovich/Documents/obsidian-vault',
        path = '~/obsidian-vault/',
      },
      -- {
      --   name = 'work',
      --   path = '~/vaults/work',
      -- },
    },

    notes_subdir = 'main',

    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = 'daily/',
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = '%Y-%m-%d',
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = '%B %-d, %Y',
      -- Optional, default tags to add to each new daily note created.
      default_tags = { 'daily' },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = 'Daily Template.md',
      -- Optional, if you want `Obsidian yesterday` to return the last work day or `Obsidian tomorrow` to return the next work day.
      workdays_only = false,
    },

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Enables completion using nvim_cmp
      nvim_cmp = false,
      -- Enables completion using blink.cmp
      blink = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
    -- way then set 'mappings = {}'.
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ['<leader>ch'] = {
        action = function()
          return require('obsidian').util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action depending on context: follow link, show notes with tag, toggle checkbox, or toggle heading fold
      ['<cr>'] = {
        action = function()
          return require('obsidian').util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },

    -- Either 'wiki' or 'markdown'.
    preferred_link_style = 'wiki',

    -- Optional, for templates (see https://github.com/obsidian-nvim/obsidian.nvim/wiki/Using-templates)
    templates = {
      folder = 'templates/',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {
        yesterday = function()
          return os.date('%Y-%m-%d', os.time() - 86400)
        end,
        tomorrow = function()
          return os.date('%Y-%m-%d', os.time() + 86400)
        end,
      },
    },

    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      local date_str = os.date '%Y%m%d'
      local suffix = ''
      if title ~= nil then
        -- NOTE: Можно будет при надобности сделать чтобы любой татл с префиксом по типу XX- не добалял префикс
        if title:match '^PP%-' or title:match '^IN%-' or title:match '^EN%-' then
          return title
        end
        -- Для английских названий: lowercase, дефисы, только безопасные символы
        suffix = title
          :gsub('%s+', '-') -- Заменяем пробелы на дефисы
          :gsub('[^%w%-]', '') -- Удаляем все кроме букв, цифр и дефисов
          :gsub('-+', '-') -- Объединяем множественные дефисы
          :gsub('^-', '') -- Убираем дефис в начале
          :gsub('-$', '') -- Убираем дефис в конце
          :lower() -- Все в нижний регистр
      else
        -- Если заголовок не задан, генерируем случайный суффикс
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(97, 122)) -- lowercase letters
        end
      end
      return date_str .. '-' .. suffix
    end,

    -- Optional, customize how note file names are generated given the ID, target directory, and title.
    ---@param spec { id: string, dir: obsidian.Path, title: string|? }
    ---@return string|obsidian.Path The full path to the new note.
    note_path_func = function(spec)
      -- This is equivalent to the default behavior.
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix '.md'
    end,

    -- Sets how you follow URLs
    ---@param url string
    follow_url_func = function(url)
      vim.ui.open(url)
      -- vim.ui.open(url, { cmd = { "firefox" } })
    end,

    -- Sets how you follow images
    ---@param img string
    follow_img_func = function(img)
      local corrected_path = img:gsub('obsidian%-vault/', 'obsidian-vault/files/')
      print('Trying to open image:', corrected_path)
      vim.ui.open(corrected_path, { cmd = { 'wsl-open' } })
    end,

    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
      -- name = 'snacks.pick',
      name = 'telescope.nvim',
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      note_mappings = {
        -- Create a new note from your query.
        new = '<C-x>',
        -- Insert a link to the selected note.
        insert_link = '<C-l>', -- TODO: wont work
      },
      tag_mappings = {
        -- Add tag(s) to current note.
        tag_note = '<C-x>',
        -- Insert a tag at the current location.
        insert_tag = '<C-l>', -- TODO: wont work
      },
    },

    attachments = {
      img_folder = './files',
    },
  },

  new_notes_location = 'notes_subdir',

  statusline = {
    enabled = true,
    format = '{{properties}} properties {{backlinks}} backlinks {{words}} words {{chars}} chars',
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
    vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian template<CR>', { desc = 'Show Obsidian Dailies' })
    vim.keymap.set('n', '<leader>om', '<cmd>Obsidian tags<CR>', { desc = 'Obsidian Tags' })
  end,
}
