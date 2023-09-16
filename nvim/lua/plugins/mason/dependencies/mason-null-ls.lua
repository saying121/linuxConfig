return {
    "jayp0521/mason-null-ls.nvim",
    cond = false,
    config = function()
        require("mason-null-ls").setup({
            ensure_installed = {
                "black",
                "stylua",
                "prettier",
                "shfmt",
                "beautysh",
                "latexindent",
                "golines",
            },
            automatic_installation = true,
            automatic_setup = false,
        })
    end,
}
