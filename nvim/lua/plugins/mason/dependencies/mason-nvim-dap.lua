return {
    "jayp0521/mason-nvim-dap.nvim",
    config = function()
        require("mason-nvim-dap").setup({
            ensure_installed = {
                "bash",
                "delve",
                -- "javadbg",
                "python",
                "codelldb",
            },
            automatic_installation = true,
            automatic_setup = false,
        })
    end,
}
