local choose_base = function(cb)
  local lines = vim.fn.systemlist 'git branch -r --format="%(refname:short)"'

  local allowed = {
    dev = true,
    master = true,
    release = true,
    main = true,
    KPI = true,
    CORE = true,
  }

  local branches = {}
  for _, branch in ipairs(lines) do
    for key in pairs(allowed) do
      if branch == key or branch:match(key) then
        table.insert(branches, branch)
        break
      end
    end
  end

  if #branches == 0 then
    vim.notify('No branches found', vim.log.levels.WARN)
    return
  end

  vim.ui.select(branches, { prompt = 'Base branch:' }, function(base)
    if base then
      cb(base)
    end
  end)
end

return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      -- Correct fileformat for right gitsigns indication
      if vim.bo.fileformat == 'dos' then
        vim.bo.fileformat = 'unix'
      end

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Jump to next git [c]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Jump to previous git [c]hange' })

      -- Actions
      -- visual mode
      map('v', '<leader>hs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'stage git hunk' })
      map('v', '<leader>hr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'reset git hunk' })
      -- normal mode
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
      map('n', '<leader>bs', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
      map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
      map('n', '<leader>br', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
      map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
      map('n', '<leader>hD', gitsigns.diffthis, { desc = 'git [d]iff against index' })
      map('n', '<leader>hd', function()
        gitsigns.diffthis '@'
      end, { desc = 'git [D]iff against last commit' })
      -- Toggles
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
      map('n', '<leader>tg', gitsigns.toggle_deleted, { desc = '[T]oggle [g]it show deleted' })
      map('n', '<leader>hB', gitsigns.blame, { desc = '[T]oggle Blame' })
      map('n', '<leader>hcb', function()
        choose_base(function(base)
          gitsigns.change_base(base)
        end)
      end, { desc = '[C]hange [B]ase' })
      map('n', '<leader>hcr', gitsigns.reset_base, { desc = 'Reset Base' })
      map('n', '<leader>ha', function()
        choose_base(function(base)
          require('gitsigns').diffthis(base)
        end)
      end, { desc = 'git [D]iff against base branch' })
    end,
  },
}
