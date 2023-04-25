return {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        -- 依赖会先加载。neodev 要在 nvim-lspconfig 之前加载。
        {
            "folke/neodev.nvim",
            cond = function()
                return vim.bo.ft == "lua" or false
            end,
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
                            "plenary.nvim",
                            "nvim-treesitter",
                            -- "nvim-lspconfig",
                            "nvim-cmp",
                            "telescope.nvim",
                            "LuaSnip",
                            -- "neoscroll.nvim",
                            -- "lazy.nvim",
                            -- "rust-tools.nvim",
                            -- "lspsaga.nvim",
                            -- "noice.nvim",
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
        {
            "wlh320/rime-ls",
            keys = { "<A-h>" },
            config = function()
                local R = {}
                function R.setup_rime()
                    -- global status
                    vim.g.rime_enabled = false
                    -- add rime-ls to lspconfig as a custom server
                    require("lspconfig.configs").rime_ls = {
                        default_config = {
                            name = "rime_ls",
                            cmd = { "rime_ls" },
                            filetypes = { "*" },
                            single_file_support = true,
                        },
                        settings = {},
                        docs = {
                            description = [[
https://www.github.com/wlh320/rime-ls

A language server for librime
]],
                        },
                    }

                    local rime_on_attach = function(client, _)
                        local toggle_rime = function()
                            client.request(
                                "workspace/executeCommand",
                                { command = "rime-ls.toggle-rime" },
                                function(_, result, ctx, _)
                                    if ctx.client_id == client.id then
                                        vim.g.rime_enabled = result
                                    end
                                end
                            )
                        end
                        vim.keymap.set({ "n", "i" }, "<A-h>", function()
                            toggle_rime()
                        end)
                        vim.keymap.set("n", "<leader>rs", function()
                            vim.lsp.buf.execute_command({ command = "rime-ls.sync-user-data" })
                        end)
                    end

                    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
                    local capabilities = vim.lsp.protocol.make_client_capabilities()
                    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

                    require("lspconfig").rime_ls.setup({
                        init_options = {
                            enabled = vim.g.rime_enabled,
                            shared_data_dir = "/usr/share/rime-data",
                            user_data_dir = vim.fn.getenv("HOME") .. "/.local/share/rime-ls-nvim",
                            log_dir = vim.fn.getenv("HOME") .. "/.local/share/rime-ls-nvim",
                            max_candidates = 9,
                            -- trigger_characters = { '::' },
                        },
                        on_attach = rime_on_attach,
                        capabilities = capabilities,
                    })
                end

                R.setup_rime()
                -- rime-ls 不能懒加载
                -- 为了开启rime-ls,好像也能开启lsp
                vim.cmd("e %")
            end,
        },
    },
    config = function()
        require("lspconfig.ui.windows").default_options.border = "single"

        local LSP = require("public.lsp_attach")

        -- 要禁用某个 lsp 就去改后缀名
        local lsp_path = vim.fn.stdpath("config") .. "/lua/lsp"
        local file_name_list = vim.fn.readdir(lsp_path)

        for _, the_file_name in pairs(file_name_list) do
            if vim.endswith(the_file_name, ".lua") then
                local lsp_name = string.sub(the_file_name, 1, #the_file_name - 4)

                -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
                local capabilities = require("cmp_nvim_lsp").default_capabilities()
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

        -- VeryLazy 情况要显示启动
        vim.cmd("LspStart")
    end,
}
