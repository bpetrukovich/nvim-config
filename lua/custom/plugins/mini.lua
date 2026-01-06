return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }
    -- require('mini.files').setup( -- No need to copy this inside `setup()`. Will be used automatically.
    --   {
    --     -- Customization of shown content
    --     content = {
    --       -- Predicate for which file system entries to show
    --       filter = nil,
    --       -- Highlight group to use for a file system entry
    --       highlight = nil,
    --       -- Prefix text and highlight to show to the left of file system entry
    --       prefix = nil,
    --       -- Order in which to show file system entries
    --       sort = nil,
    --     },
    --
    --     -- Module mappings created only inside explorer.
    --     -- Use `''` (empty string) to not create one.
    --     mappings = {
    --       close = '<C-c>',
    --       go_in = '<CR>', -- actions.select
    --       -- go_in_plus = '<C-s>', -- vertical split
    --       go_out = '-', -- actions.parent
    --       go_out_plus = '_', -- go_out_plus как open_cwd
    --       show_help = 'g?',
    --       synchronize = '<C-s>', -- refresh/confirm
    --       reveal_cwd = '`', -- actions.cd/open_cwd
    --     },
    --
    --     -- General options
    --     options = {
    --       -- Whether to delete permanently or move into module-specific trash
    --       permanent_delete = true,
    --       -- Whether to use for editing directories
    --       use_as_default_explorer = true,
    --     },
    --
    --     -- Customization of explorer windows
    --     windows = {
    --       -- Maximum number of windows to show side by side
    --       max_number = math.huge,
    --       -- Whether to show preview of file/directory under cursor
    --       preview = false,
    --       -- Width of focused window
    --       width_focus = 50,
    --       -- Width of non-focused window
    --       width_nofocus = 15,
    --       -- Width of preview window
    --       width_preview = 25,
    --     },
    --   }
    -- )

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    -- require('mini.surround').setup()

    -- -- Simple and easy statusline.
    -- --  You could remove this setup call if you don't like it,
    -- --  and try some other statusline plugin
    -- local statusline = require 'mini.statusline'
    -- -- set use_icons to true if you have a Nerd Font
    -- statusline.setup { use_icons = vim.g.have_nerd_font }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    -- ---@diagnostic disable-next-line: duplicate-set-field
    -- statusline.section_location = function()
    --   return '%2l:%-2v'
    -- end

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
