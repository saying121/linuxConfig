return {
    {
        "OXY2DEV/markview.nvim",
        ft = { "markdown" },
        cond = false,
        -- branch = "dev",
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- Used by the code bloxks
        },

        config = function()
            require("markview").setup()
        end,
    },
    {
        "MeanderingProgrammer/markdown.nvim",
        main = "render-markdown",
        opts = {},
        name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
        dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    },
}
