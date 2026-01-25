---@type LazySpec
return {
    "windwp/nvim-ts-autotag",
    config = function()
        require("nvim-treesitter").setup({
            opts = {
                enable_rename = true,
                enable_close = true,
                enable_close_on_slash = true,
            },
        })
    end,
}
