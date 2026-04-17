-- Centering
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Move selected up and down.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

vim.keymap.set("n", "Q", "<Nop>")

-- Great remap to preserve yank after pasting.
vim.keymap.set("x", "<leader>p", '"_dP')

-- I know there is _ but this is much simpler, I don't like the default 0 behaviour.
vim.keymap.set("n", "0", "^")

-- Alternative to <C-d> and <C-u>, jump 10 up and down.
-- Maybe good maybe bad for my workflow, right now I like it.
vim.keymap.set("n", "<C-j>", ":normal! 10j<CR>", { silent = true })
vim.keymap.set("n", "<C-k>", ":normal! 10k<CR>", { silent = true })

-- Delete word in insert mode with ctrl backspace instead of defualt bind to <C-w>.
vim.keymap.set("i", "<C-H>", "<C-w>")

-- Remap to indent to the right level for empty lines when entering insert mode.
local function smart_insert(key)
  return function()
    local line = vim.fn.getline "."
    if line:match "^%s*$" then
      vim.cmd "normal! ^"
      if line == "" then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('"_cc', true, false, true), "n", false)
        return
      end
    end
    vim.api.nvim_feedkeys(key, "n", false)
  end
end

vim.keymap.set("n", "i", smart_insert "i")
vim.keymap.set("n", "a", smart_insert "a")

-- Clear highlights on search when pressing <Esc> in normal mode.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
