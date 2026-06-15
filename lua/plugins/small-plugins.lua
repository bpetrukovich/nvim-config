return {
  { 'kevinhwang91/nvim-bqf' },
  { 'NMAC427/guess-indent.nvim', opts = {} }, -- Detect tabstop and shiftwidth automatically
  -- "gc" to comment visual regions/lines. It more advanced than built-in nvim commenting
  { 'numToStr/Comment.nvim', opts = {} },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
  {
    'm4xshen/hardtime.nvim',
    lazy = false,
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {},
  },
  {
    'RaafatTurki/hex.nvim',
    config = function()
      require('hex').setup()
    end,
  },
  {
    'catgoose/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },

    config = function()
      require('colorizer').setup()
    end,
  },
  {
    'letieu/harpoon-lualine',
    dependencies = {
      {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
      },
    },
  },
  {
    {
      'rebelot/kanagawa.nvim',
      priority = 1000, -- Make sure to load this before all the other start plugins.
      init = function()
        vim.cmd.colorscheme 'kanagawa-dragon'

        -- Remove italic font for comments
        vim.cmd.hi 'Comment gui=none'
      end,
    },
  },
  {
    'nicholasmata/nvim-dap-cs',
    ft = { 'cs', 'razor' },
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('dap-cs').setup {
        netcoredbg = {
          path = vim.fn.expand '~/.local/share/nvim/mason/bin/netcoredbg',
        },
      }
    end,
  },
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
    config = function()
      vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', { desc = 'Preview' })
    end,
  },
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }
    end,
  },
}
