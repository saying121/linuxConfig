return {
    "kylechui/nvim-surround",
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
}
