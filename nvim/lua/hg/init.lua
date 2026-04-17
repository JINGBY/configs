require "hg.options"
require "hg.remaps"
require "hg.lazy"

local hg_group = vim.api.nvim_create_augroup("hg", {})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Remove windows newlines on :w (usually from copy-pasta).
vim.api.nvim_create_autocmd("BufWritePre", {
  group = hg_group,
  pattern = { "*" },
  command = ":%s/\\r//e",
})

-- Disable italics.
local function no_italic(group)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok and hl then
    vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, { italic = false }))
  end
end

for _, group in ipairs {
  "@lsp.mod.globalScope",
  "@lsp.typemod.macro.globalScope",
  "@lsp.type.macro",
  "@lsp",
} do
  no_italic(group)
end
