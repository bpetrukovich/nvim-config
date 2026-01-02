-- Highlight TODO, FIX, HACK, WARN, PERF, NOTE, TEST
return { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } }
