return {
  'nanozuki/tabby.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local theme = {
      fill = 'TabLineFill',

      head = {
        fg = '#C4A86A',
        bg = '#181616',
        style = 'italic',
      },

      current_tab = {
        fg = '#181616',
        bg = '#C4A86A',
        style = 'italic',
      },

      tab = {
        fg = '#A6A69C',
        bg = '#181616',
        style = 'italic',
      },

      win = {
        fg = '#181616',
        bg = '#7FB4CA', -- soft dragon blue
        style = 'italic',
      },

      tail = {
        fg = '#C4A86A',
        bg = '#181616',
        style = 'italic',
      },
    }

    local function get_tab_label(tab)
      local api = require 'tabby.module.api'
      local wins = api.get_tab_wins(tab.id)

      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.bo[buf].filetype

        if ft == 'oil' then
          local name = vim.api.nvim_buf_get_name(buf)
          local path = name:gsub('^oil://', ''):gsub('/$', '')
          local dir = vim.fn.fnamemodify(path, ':t')

          return dir ~= '' and dir or 'Oil'
        end
      end

      return nil
    end

    require('tabby.tabline').set(function(line)
      return {
        {},
        line.tabs().foreach(function(tab)
          local hl = tab.is_current() and theme.current_tab or theme.tab

          -- remove count of wins in tab with [n+] included in tab.name()
          local name = tab.name()
          local index = string.find(name, '%[%d')
          local tab_name_without_wins = index and string.sub(name, 1, index - 1) or name
          local tab_name = get_tab_label(tab) or tab_name_without_wins

          -- indicate if any of buffers in tab have unsaved changes
          local modified = false
          local win_ids = require('tabby.module.api').get_tab_wins(tab.id)
          for _, win_id in ipairs(win_ids) do
            if pcall(vim.api.nvim_win_get_buf, win_id) then
              local bufid = vim.api.nvim_win_get_buf(win_id)
              if vim.api.nvim_buf_get_option(bufid, 'modified') then
                modified = true
                break
              end
            end
          end

          return {
            line.sep('', hl, theme.fill),
            tab_name,
            modified and '',
            line.sep('', hl, theme.fill),
            hl = hl,
            margin = ' ',
          }
        end),
        line.spacer(),
        {
          line.sep('', theme.tail, theme.fill),
          { '  ', hl = theme.tail },
        },
        hl = theme.fill,
      }
    end)
  end,
}
