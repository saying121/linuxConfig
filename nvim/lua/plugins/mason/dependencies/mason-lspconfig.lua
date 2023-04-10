return {
    "williamboman/mason-lspconfig.nvim",
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "awk_ls",
                "bashls",
                "clangd",
                "emmet_ls",
                "gopls",
                "jdtls",
                "jsonls",
                "marksman",
                "pylsp",
                "texlab",
                "tsserver",
                "vimls",
                "yamlls",
                'lua_ls',
            },
            -- Can either be:
            --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
            --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
            automatic_installation = false,
        })
    end,
}
