return {
    "folke/neodev.nvim",
    cond = function()
        if string.find(vim.api.nvim_buf_get_name(0), "/nvim/") then
            return true
        end
        return false
    end,
    config = function()
        local import = {
            "plenary.nvim",
            -- "dyninput.nvim",
            -- "refactoring.nvim",
            -- "conjure",
            -- "guard.nvim",
            -- "crates.nvim",
            -- "alpha-nvim",
            -- "lspkind.nvim",
            -- "neotest",
            -- "neotest-rust",
            -- "nvim-treesitter",
            -- "nvim-lspconfig",
            -- "cmp-nvim-lsp",
            -- "nvim-cmp",
            -- "nvim-ufo",
            "telescope.nvim",
            -- "LuaSnip",
            -- "neoscroll.nvim",
            -- "lazy.nvim",
            "rust-tools.nvim",
            -- "lspsaga.nvim",
            -- "noice.nvim",
        }

        -- if vim.fn.expand("%:t") then
        --     table.insert(import, "")
        -- end

        require("neodev").setup({
            library = {
                enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
                -- these settings will be used for your Neovim config directory
                runtime = true, -- runtime path
                types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
                -- plugins = true, -- installed opt or start plugins in packpath
                -- you can also specify the list of plugins to make available as a workspace library
                plugins = import,
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
}
