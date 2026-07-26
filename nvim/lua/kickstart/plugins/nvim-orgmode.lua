return {
  'nvim-orgmode/orgmode',
  lazy = false,
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    -- Basic orgmode setup
    require('orgmode').setup {
      org_agenda_files = { '~/org/*' },
      org_default_notes_file = '~/org/refile.org',
    }

    -- Optional: set TODO keywords
    vim.g.org_todo_keywords = { 'TODO', 'WAITING', '|', 'DONE', 'CANCELLED' }
  end,
}
