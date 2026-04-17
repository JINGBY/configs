vim.o.number = true
vim.o.relativenumber = true
vim.o.fillchars = "eob: " -- Remove useless tilde signs at the end of buffer.
vim.o.wrap = false

-- NOTE: 4 works generally, prefably i would want to split so that frontend stuff does 2, the rest 4 or 8
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

vim.o.mouse = "a" -- Enable mouse mode, can be useful sometimes.
vim.o.showmode = false -- Don't show the mode, since it's already in the status line.

-- Sync clipboard between OS and Neovim.
-- TODO: Decide what to do.
vim.o.clipboard = "unnamedplus"

vim.o.breakindent = true -- Make wrapped text retain indentation level  NOTE: Only needed if wrap = true.
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"

vim.o.updatetime = 250 -- Decrease update time.
vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time.

vim.o.splitright = true -- I only want left/right splits.
vim.o.inccommand = "split" -- Live substitution previews.

vim.o.cursorline = true -- Highlight current line.
vim.o.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.

vim.o.confirm = true -- Ask for comfirmations before :q on unsaved changes.

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = "none", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },

  virtual_text = true, -- End of the line
  virtual_lines = false, -- Underneath the line

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}
