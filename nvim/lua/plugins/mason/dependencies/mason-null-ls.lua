return {
    "jayp0521/mason-null-ls.nvim",
    config = function()
        require("mason-null-ls").setup({
            ensure_installed = {
                "black",
                "stylua",
                "isort",
                "prettier",
                "shfmt",
                "vint",
                "beautysh",
                "latexindent",
                "golines",
            },
            automatic_installation = true,
            automatic_setup = false,
        })
    end,
}
