return {
    "windwp/nvim-ts-autotag",
    config = function()
        require("nvim-treesitter.configs").setup({
            autotag = {
                enable = true,
                enable_rename = true,
                enable_close = true,
                enable_close_on_slash = true,
            },
        })
    end,
}
