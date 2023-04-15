return {
    "norcalli/nvim-colorizer.lua",
    cond = false,
    event = "VeryLazy",
    config = function()
        require("colorizer").setup()
    end,
}
