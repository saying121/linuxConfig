local nvim_lsp = {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
        -- 依赖会先加载
        {
            "folke/neodev.nvim",
            ft = "lua",
            config = function()
                require("neodev").setup({
                    library = {
                        enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
                        -- these settings will be used for your Neovim config directory
                        runtime = true, -- runtime path
                        types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
                        -- plugins = true, -- installed opt or start plugins in packpath
                        -- you can also specify the list of plugins to make available as a workspace library
                        plugins = {
                            "nvim-treesitter",
                            "plenary.nvim",
                            "telescope.nvim",
                            "lazy.nvim",
                            "rust-tools.nvim",
                            "lspsaga.nvim",
                        },
                    },
                    setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
                    -- for your Neovim config directory, the config.library settings will be used as is
                    -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
                    -- for any other directory, config.library.enabled will be set to false
                    -- override = function(root_dir, options) end,
                    -- With lspconfig, Neodev will automatically setup your lua-language-server
                    -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
                    -- in your lsp start options
                    lspconfig = true,
                    -- much faster, but needs a recent built of lua-language-server
                    -- needs lua-language-server >= 3.6.0
                    pathStrict = true,
                })
            end,
        },
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        require("lspconfig.ui.windows").default_options.border = "single"

        local signs = {
            { name = "DiagnosticSignError", text = " " },
            { name = "DiagnosticSignWarn", text = " " },
            { name = "DiagnosticSignHint", text = " " },
            { name = "DiagnosticSignInfo", text = " " },
        }
        for _, sign in ipairs(signs) do
            vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end
        -- 边框
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "single",
        })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "single",
        })
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            update_in_insert = true,
            underline = true,
            float = { border = "single" },
        })

        local LSP = require("public.lsp_attach")

        -- 要禁用某个 lsp 就去改后缀名
        local lsp_path = vim.fn.stdpath("config") .. "/lua/lsp"
        local file_name_list = vim.fn.readdir(lsp_path)

        for _, the_file_name in pairs(file_name_list) do
            if string.sub(the_file_name, #the_file_name - 3) == ".lua" then
                local lsp_name = string.sub(the_file_name, 1, #the_file_name - 4)

                local capabilities = LSP.capabilities
                if lsp_name == "clangd" then
                    capabilities.offsetEncoding = { "utf-16" }
                end

                require("lspconfig")[lsp_name].setup({
                    capabilities = capabilities,
                    on_attach = LSP.on_attach,
                    flags = LSP.lsp_flags,
                    settings = require("lsp." .. lsp_name),
                })
            end
        end
    end,
}

return nvim_lsp
