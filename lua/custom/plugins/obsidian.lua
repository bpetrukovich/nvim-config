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
        path = '~/obsidian-vault',
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
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ''
      if title ~= nil then
        -- if title is ticket number than returning it without suffix
        if title:match '^PP%-' or title:match '^IN%-' then
          return title
        end
        -- If title is given, transform it into valid file name.
        suffix = title:gsub('%s+', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
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
      name = 'telescope.nvim',
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      note_mappings = {
        -- Create a new note from your query.
        new = '<C-x>',
        -- Insert a link to the selected note.
        insert_link = '<C-l>',
      },
      tag_mappings = {
        -- Add tag(s) to current note.
        tag_note = '<C-x>',
        -- Insert a tag at the current location.
        insert_tag = '<C-l>',
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
