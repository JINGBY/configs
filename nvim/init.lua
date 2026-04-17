vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Options ]]

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

-- [[ Keymaps ]]

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

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- [[ Autocommands ]]

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Install lazy plugin manager.
-- TODO: Switch to the built-in plugin manager in 0.12 sometime.
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- Configure and install plugins.
require("lazy").setup {
  "NMAC427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically.

  { -- Adds git related signs to the gutter, as well as utilities for managing changes.
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    opts = {
      delay = 0, -- Delay between pressing a key and opening which-key (milliseconds).
      icons = {
        mappings = false,
        keys = {
          Up = "<Up> ",
          Down = "<Down> ",
          Left = "<Left> ",
          Right = "<Right> ",
          C = "<C-…> ",
          M = "<M-…> ",
          D = "<D-…> ",
          S = "<S-…> ",
          CR = "<CR> ",
          Esc = "<Esc> ",
          ScrollWheelDown = "<ScrollWheelDown> ",
          ScrollWheelUp = "<ScrollWheelUp> ",
          NL = "<NL> ",
          BS = "<BS> ",
          Space = "<Space> ",
          Tab = "<Tab> ",
          F1 = "<F1>",
          F2 = "<F2>",
          F3 = "<F3>",
          F4 = "<F4>",
          F5 = "<F5>",
          F6 = "<F6>",
          F7 = "<F7>",
          F8 = "<F8>",
          F9 = "<F9>",
          F10 = "<F10>",
          F11 = "<F11>",
          F12 = "<F12>",
        },
      },

      -- Document existing key chains.
      spec = {
        { "<leader>s", group = "[S]earch" },
        { "<leader>t", group = "[T]oggle" },
        { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
      },
    },
  },

  { -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = function()
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed.
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require "telescope.builtin"
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

      vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = "[/] Fuzzily search in current buffer" })

      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        }
      end, { desc = "[S]earch [/] in Open Files" })
    end,
  },

  {
    "stevearc/oil.nvim",
    opts = {
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
    },
    lazy = false,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Mason must be loaded before its dependents so we need to set it up here.
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP.
      { "j-hui/fidget.nvim", opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      "saghen/blink.cmp",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
          map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          local builtin = require "telescope.builtin"

          map("grr", builtin.lsp_references, "[G]oto [R]eferences")
          map("gri", builtin.lsp_implementations, "[G]oto [I]mplementation")
          map("grd", builtin.lsp_definitions, "[G]oto [D]efinition")
          map("grt", builtin.lsp_type_definitions, "[G]oto [T]ype Definition")

          map("gO", builtin.lsp_document_symbols, "Open Document Symbols")
          map("gW", builtin.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

          -- Keymap to toggle inlay hints in your code, if the language server you are using supports them.
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/inlayHint", event.buf) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local servers = {
        clangd = {},
        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              -- Ignore Lua_LS's noisy `missing-fields` warnings.
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },
        ts_ls = {},
        svelte = {},
        cssls = {},
        tailwindcss = {},
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua",
        "svelte-language-server",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "prettier",
        "clangd",
      })

      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      require("mason-lspconfig").setup {
        ensure_installed = {}, -- explicitly set to an empty table (populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      }

      -- Special Lua Config, as recommended by neovim help docs.
      vim.lsp.config("lua_ls", {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath "config" and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT",
              path = { "lua/?.lua", "lua/?/init.lua" },
            },
            workspace = {
              checkThirdParty = false,
              -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
              --  See https://github.com/neovim/nvim-lspconfig/issues/3189
              library = vim.api.nvim_get_runtime_file("", true),
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })
      vim.lsp.enable "lua_ls"
    end,
  },

  { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format { async = true, lsp_format = "fallback" }
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = "fallback",
          }
        end
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },

        javascript = { "prettier_if_present" },
        typescript = { "prettier_if_present" },
        svelte = { "prettier-plugin-svelte" },
        -- You can use 'stop_after_first' to run the first available formatter from the list
        --[[ svelte = { 'prettierd', 'prettier', stop_after_first = true }, ]]
      },
    },
  },

  { -- Autocompletion
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*",
    dependencies = {
      -- Snippet Engine
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {},
        opts = {},
      },
      "folke/lazydev.nvim",
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = "super-tab",
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { "lsp", "path", "snippets" },
      },

      snippets = { preset = "luasnip" },

      fuzzy = { implementation = "lua" },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },

  {
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
  },

  { "folke/todo-comments.nvim", event = "VimEnter", dependencies = { "nvim-lua/plenary.nvim" }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      require("mini.ai").setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      require("mini.surround").setup()

      -- Simple statusline
      local statusline = require "mini.statusline"
      statusline.setup { use_icons = false }

      -- Set the section for cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return "%2l:%-2v"
      end
    end,
  },

  -- NOTE: requires tree-sitter-cli

  { -- Highlight, edit, and navigate code
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
  },

  require "kickstart.plugins.autopairs",
  require "kickstart.plugins.comment",
  require "kickstart.plugins.autotag",
}

-- Remove windows newlines on :w (usually from copy-pasta).
vim.api.nvim_create_autocmd("BufWritePre", {
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
