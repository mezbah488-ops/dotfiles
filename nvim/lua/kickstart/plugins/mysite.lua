return {
  'mezbah488-ops/mysite.nvim',
  -- The 'keys' table registers your shortcuts with Lazy
  keys = {
    { '<leader>cn', ':MySiteNew<CR>', desc = 'New Entry' },
    { '<leader>cb', ':MySiteBuild<CR>', desc = 'Build Index' },
  },
  config = function()
    require('mysite').setup {
      directories = { 'essays', 'journal', 'notes' }, -- Folders to track
      template = 'template.html', -- Your base template
      index_file = 'index.html', -- Your landing page
      auto_build = true, -- Build on save
    }
  end,
}
