return {
    "danymat/neogen",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "L3MON4D3/LuaSnip",
    },
    version = "*",
    cmd = "Neogen",
    keys = {
        { "<C-S-e>", mode = { "n", "x" } },
        { "<C-S-a>", mode = { "n", "x" } },
    },
    config = function()
        local keymap = vim.keymap.set
        keymap({ "n", "x" }, "<C-S-e>", "<Cmd>Neogen file<CR>", { noremap = true, silent = true })
        keymap({ "n", "x" }, "<C-S-a>", "<Cmd>Neogen<CR>", { noremap = true, silent = true })

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
