---@type LazySpec
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
        local keymap, opts = vim.keymap.set, { noremap = true, silent = true }

        keymap({ "n", "x" }, "<C-S-e>", function()
            require("neogen").generate({
                type = "file", -- the annotation type to generate. Currently supported: func, class, type, file
            })
        end, opts)
        keymap({ "n", "x" }, "<C-S-a>", function()
            require("neogen").generate()
        end, opts)

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
                        annotation_convention = "rustdoc", -- 'rust_alternative','rustdoc'
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
