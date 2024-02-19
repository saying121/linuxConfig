return {
    "numToStr/Comment.nvim",
    keys = {
        { "gc", mode = { "n", "x" } },
        { "gb", mode = { "n", "x" } },
    },
    config = function()
        require("Comment").setup({})

        local ft = require("Comment.ft")
        ft.hyprlang = { "#%s" }
        ft.PKGBUILD = { "#%s" }
    end,
}
