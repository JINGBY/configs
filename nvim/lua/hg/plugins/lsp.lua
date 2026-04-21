return {
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

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Disble native color highlighting, I do not like it.
        if client and client.server_capabilities.colorProvider then
          vim.lsp.document_color.enable(false, { bufnr = event.buf })
        end

        -- Keymap to toggle inlay hints in your code, if the language server you are using supports them.
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
}
