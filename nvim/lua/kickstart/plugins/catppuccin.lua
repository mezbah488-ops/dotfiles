-- lua/kickstart/plugins/catppuccin.lua
return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- load first
    config = function()
      local status, catppuccin = pcall(require, 'catppuccin')
      if not status then
        return
      end

      catppuccin.setup {
        flavour = 'auto',
        background = { light = 'latte', dark = 'frappe' },
        transparent_background = false, -- change to true if you want transparency
        float = { transparent = false, solid = false },
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = { enabled = false, shade = 'dark', percentage = 0.15 },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { 'italic' },
          conditionals = { 'italic' },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        lsp_styles = {
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
            ok = { 'italic' },
          },
          underlines = {
            errors = { 'underline' },
            hints = { 'underline' },
            warnings = { 'underline' },
            information = { 'underline' },
            ok = { 'underline' },
          },
          inlay_hints = { background = true },
        },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
        auto_integrations = false,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          notify = false,
          mini = { enabled = true, indentscope_color = '' },
        },
      }

      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
