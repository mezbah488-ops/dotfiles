local map = vim.keymap.set

-- Auto-start inkscape-figures watcher
vim.fn.jobstart('inkscape-figures watch', {
  detach = true,
  on_stderr = function() end,
})

-- Create new figure (type figure name on a line, press <leader>fi in normal mode)
map('n', '<leader>fi', function()
  local line = vim.api.nvim_get_current_line():match '^%s*(.-)%s*$'
  if line == '' then
    return
  end
  local root = vim.fn.expand '%:p:h'
  local output = vim.fn.system(string.format("inkscape-figures create '%s' '%s/figures/'", line, root))
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, vim.split(output, '\n', { trimempty = true }))
end, { buffer = true })

-- Edit existing figure (<leader>fe opens fuzzy picker in terminal split)
map('n', '<leader>fe', function()
  local root = vim.fn.expand '%:p:h'
  vim.cmd('split | terminal inkscape-figures edit \'' .. root .. '/figures/\'')
end, { buffer = true })
