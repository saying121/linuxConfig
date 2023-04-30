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
                "powershell_es",
                "texlab",
                "tsserver",
                "vimls",
                "yamlls",
                'lua_ls',
            },
            automatic_installation = false,
        })
    end,
}
