return {
  "JINGBY/hg.nvim",
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    require("neomodern").setup {
      theme = "iceclimber",
      variant = "dark",
      code_style = {
        comments = "none",
      },
    }
    require("neomodern").load()
  end,
}
