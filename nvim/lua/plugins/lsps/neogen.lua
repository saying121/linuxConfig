return {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    version = "*",
    cmd = "Neogen",
    keys = { "<C-S-a>", mode = { "n", "v" } },
    config = function()
        vim.keymap.set({ "n", "v" }, "<C-S-a>", ":Neogen<CR>", { noremap = true, silent = true })
        require("neogen").setup({
            snippet_engine = "luasnip",
            languages = {
                lua = {
                    template = {
                        annotation_convention = "emmylua", -- 'ldoc' -- for a full list of annotation_conventions, see supported-languages below,
                        use_default_comment = true, -- for more template configurations, see the language's configuration file in configurations/{lang}.lua
                    },
                },
                rust = {
                    template = {
                        annotation_convention = "rust_alternative", -- 'rust_alternative','rustdoc'
                        use_default_comment = true,
                    },
                },
                python = {
                    template = {
                        annotation_convention = "google_docstrings", -- "google_docstrings" "numpydoc" "reST"
                        use_default_comment = true,
                    },
                },
            },
        })
    end,
}
