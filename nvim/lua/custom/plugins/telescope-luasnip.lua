return {
  {
    "benfowler/telescope-luasnip.nvim",
    dependencies = { "L3MON4D3/LuaSnip" },
    config = function()
      require("telescope").load_extension("luasnip")
    end,
  },
}
