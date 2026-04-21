return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup {
      install_dir = vim.fn.stdpath "data" .. "/site",
    }

    local filetypes = {
      "bash",
      "c",
      "diff",
      "html",
      "javascript",
      "typescript",
      "svelte",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "vim",
      "vimdoc",
    }
    require("nvim-treesitter").install(filetypes)

    -- Enable highlighting for all the filetypes you care about
    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
