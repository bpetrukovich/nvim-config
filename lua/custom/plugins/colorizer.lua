return {
  'norcalli/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup {
      user_default_options = {
        tailwind = true,
        css = true,
        sass = { enable = true, parsers = { 'css' } },
      },
    }
  end,
}
