-- lua/kickstart/plugins/autopairs.lua
return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require 'nvim-autopairs'
    npairs.setup {
      check_ts = true, -- enable Tree-sitter awareness
      enable_check_bracket_line = false,
    }

    -- Disable default autopairing for ' and "
    npairs.remove_rule "'"
    npairs.remove_rule '"'

    local Rule = require 'nvim-autopairs.rule'
    local cond = require 'nvim-autopairs.conds'

    -- Pair $ for inline math in LaTeX and Markdown
    npairs.add_rules {
      Rule('$', '$', { 'tex', 'latex', 'markdown' })
        :with_pair(function(opts)
          -- Only pair if the next char is not already $
          return opts.line:sub(opts.col, opts.col) ~= '$'
        end)
        :with_move(cond.none())
        :with_del(cond.none())
        :use_key '$',
    }

    -- You already get standard autopairs for (), {}, [], "", ''
    -- with Tree-sitter awareness enabled
  end,
}
