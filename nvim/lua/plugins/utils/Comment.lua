return {
    "numToStr/Comment.nvim",
    keys = {
        { "gc", mode = { "n", "x" } },
        { "gb", mode = { "n", "x" } },
    },
    config = function()
        require("Comment").setup()
    end,
}
