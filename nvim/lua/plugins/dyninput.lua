return {
    "nvimdev/dyninput.nvim",
    cond = function()
        return vim.fn.has("nvim-0.10.0") == 1
    end,
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        local rs = require("dyninput.lang.rust")
        local ms = require("dyninput.lang.misc")
        require("dyninput").setup({
            c = {
                ["-"] = {
                    { "->", ms.c_struct_pointer },
                    { "_", ms.snake_case },
                },
            },
            rust = {
                [";"] = {
                    { "::", rs.double_colon },
                    { ": ", rs.single_colon },
                },
                ["="] = { " => ", rs.fat_arrow },
                ["-"] = {
                    { " -> ", rs.thin_arrow },
                    { "_", ms.snake_case },
                },
                ["\\"] = { "|!| {}", rs.closure_fn },
            },
        })
    end,
}
