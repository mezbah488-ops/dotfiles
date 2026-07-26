return {
  'rmagatti/auto-session',
  lazy = false,
  config = function()
    require('auto-session').setup {
      log_level = 'error',
      auto_restore = true,
      auto_save = true,
      suppressed_dirs = { '~/', '/' },
    }
  end,
}
