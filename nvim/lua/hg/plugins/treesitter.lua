return {
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  config = function()
    local filetypes =
      { "bash", "c", "diff", "html", "javascript", "typescript", "svelte", "lua", "luadoc", "markdown", "markdown_inline", "query", "vim", "vimdoc" }

    require("nvim-treesitter").install(filetypes)

    require("nvim-treesitter").setup {
      ensure_installed = filetypes,
      highlight = { enable = true },
    }
  end,
}
