-- lua/plugins/alpha.lua
return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-mini/mini.icons' },
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Header
    dashboard.section.header.val = {
      '                                                     ',
      '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
      '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
      '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
      '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
      '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
      '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
      '                                                     ',
    }

    -- Buttons
    dashboard.section.buttons.val = {
      dashboard.button('e', '  New file', '<cmd>ene <BAR> startinsert<CR>'),
      dashboard.button('f', '  Find file', '<cmd>Telescope find_files<CR>'),
      dashboard.button('r', '  Recent files', '<cmd>Telescope oldfiles<CR>'),
      dashboard.button('n', '  Find nvim files', "<cmd>lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })<CR>"),
      dashboard.button('g', '  Live grep', '<cmd>Telescope live_grep<CR>'),
      dashboard.button('s', '  Sessions', '<cmd>AutoSession search<CR>'),
      dashboard.button('l', '  Lazy', '<cmd>Lazy<CR>'),
      dashboard.button('q', '  Quit', '<cmd>qa<CR>'),
    }

    -- Footer
    local function footer()
      local stats = require('lazy').stats()
      return string.format('⚡ %d plugins loaded in %.2fms', stats.loaded, stats.startuptime)
    end

    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = 'Comment'

    -- Layout
    dashboard.config.layout = {
      { type = 'padding', val = 2 },
      dashboard.section.header,
      { type = 'padding', val = 2 },
      dashboard.section.buttons,
      { type = 'padding', val = 1 },
      dashboard.section.footer,
    }

    alpha.setup(dashboard.config)

    -- Refresh footer after lazy is done loading
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyVimStarted',
      callback = function()
        dashboard.section.footer.val = footer()
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
