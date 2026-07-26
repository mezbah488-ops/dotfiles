-- lua/plugins/colorscheme.lua (or wherever your colorscheme plugins live)
return {
  {
    'sainnhe/gruvbox-material',
    lazy = false, -- load during startup since it's a colorscheme
    priority = 1000, -- load before other plugins
    config = function()
      -- Recommended settings (set BEFORE colorscheme is applied)
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_background = 'medium' -- 'soft' | 'medium' | 'hard'
      vim.g.gruvbox_material_foreground = 'material' -- 'material' | 'mix' | 'original'
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_transparent_background = 1

      -- Uncomment to activate immediately instead of Kanagawa:
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
