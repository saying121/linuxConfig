---@type LazySpec
return {
    "numToStr/Comment.nvim",
    keys = {
        { "gcc", mode = { "n" } },
        { "gcA", mode = { "n" } },
        { "gco", mode = { "n" } },
        { "gcO", mode = { "n" } },
        { "gc", mode = { "x" } },
        { "gbc", mode = { "n" } },
        { "gb", mode = { "x" } },
    },
    config = function()
        require("Comment").setup()

        local ft = require("Comment.ft")

        ft({ "toml", "graphql", "PKGBUILD" }, "#%s")
        ft({ "go", "rust", "wit" }, ft.get("c"))
    end,
}
