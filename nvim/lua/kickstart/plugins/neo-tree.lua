-- Neo-tree: modern file explorer for Neovim
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*', -- or use branch = "v3.x"
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- optional but recommended for icons
    'MunifTanjim/nui.nvim',
  },
  lazy = false,

  keys = {
    { '<leader>e', ':Neotree focus reveal<CR>', desc = 'Focus and Reveal in NeoTree', silent = true },
    { '<leader>E', ':Neotree toggle<CR>', desc = 'Toggle NeoTree', silent = true },
  },

  opts = {
    filesystem = {
      filtered_items = {
        hide_by_name = { 'System Volume Information', '$RECYCLE.BIN' },
        hide_by_pattern = { '*.tmp', '*.log' },
        hide_dotfiles = false,
        hide_gitignored = true,
      },
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      window = {
        position = 'left',
        width = 30,
      },
      sort_function = nil, -- disable deep_sort completely for speed
    },

    window = {
      mappings = {
        ['<leader>e'] = 'close_window',
      },
    },
  },

  config = function(_, opts)
    local neo_tree = require 'neo-tree'

    -- Setup Neo-tree with options
    neo_tree.setup(opts)

    -- Auto-open Neo-tree when starting Neovim with a directory
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        local args = vim.fn.argv()
        if #args == 1 and vim.fn.isdirectory(args[1]) == 1 then
          vim.cmd.cd(args[1])
          require('neo-tree.command').execute {
            source = 'filesystem',
            position = 'left',
            reveal = true,
          }
        end
      end,
    })

    -- Auto-close Neo-tree if it's the only **real window**
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        local wins = vim.api.nvim_list_wins()
        if #wins == 1 then
          local buf = vim.api.nvim_get_current_buf()
          local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
          if ft == 'neo-tree' then
            vim.cmd 'quit'
          end
        end
      end,
    })
  end,
}
