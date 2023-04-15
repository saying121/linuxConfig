return {
    {
        "tpope/vim-surround",
        keys = {
            { "ys", mode = "n" },
            { "yS", mode = "n" },
            { "ds", mode = "n" },
            { "cs", mode = "n" },
            { "S", mode = "v" },
        },
        dependencies = {
            "tpope/vim-repeat",
        },
    },
    {
        "kylechui/nvim-surround",
        -- select 的 S 有问题，用 surround.vim
        enabled = false,
        keys = {
            { "ys", mode = "n" },
            { "yS", mode = "n" },
            { "ds", mode = "n" },
            { "cs", mode = "n" },
            { "S", mode = "v" },
        },
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({})
        end,
    },
}
