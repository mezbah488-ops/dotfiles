return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>fr',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      tex = { 'tex-fmt' },
      plaintex = { 'tex-fmt' },
    },
    formatters = {
      ['tex-fmt'] = {
        command = 'tex-fmt',
        args = { '--stdin', '--tabsize', '4', '--nowrap' },
        stdin = true,
      },
    },
  },
}
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
-- The following config is for the latexindent one. Comment and uncomment to enable or disable these.
--
-- return {
--   'stevearc/conform.nvim',
--   event = { 'BufWritePre' },
--   cmd = { 'ConformInfo' },
--   keys = {
--     {
--       '<leader>ft',
--       function()
--         require('conform').format { async = true, lsp_format = 'fallback', timeout_ms = 5000 }
--       end,
--       mode = '',
--     },
--   },
--   opts = {
--     notify_on_error = true,
--     format_on_save = function(bufnr)
--       local disable_filetypes = {}
--       if disable_filetypes[vim.bo[bufnr].filetype] then
--         return nil
--       end
--       local timeout = (vim.bo[bufnr].filetype == 'tex' or vim.bo[bufnr].filetype == 'plaintex') and 30000 or 500
--       return {
--         timeout_ms = timeout,
--         lsp_format = 'fallback',
--       }
--     end,
--     formatters_by_ft = {
--       lua = { 'stylua' },
--       tex = { 'latexindent' },
--       plaintex = { 'latexindent' },
--     },
--     formatters = {
--       latexindent = {
--         command = 'latexindent',
--         args = { '-y', "defaultIndent: '  '", '-l', '-' }, -- read from stdin, use local settings if present
--         stdin = true,
--       },
--     },
--   },
-- }
