return {
    {
        "OXY2DEV/markview.nvim",
        ft = { "markdown", "Avante" },
        -- cond = false,
        -- branch = "dev",
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- Used by the code bloxks
        },
        ---@type mkv.config
        opts = {
            preview = {
                filetypes = { "markdown", "Avante" },
                ignore_buftypes = {},
            },
            max_length = 99999,
        },
    },
    {
        "MeanderingProgrammer/render-markdown",
        cond = false,
        ft = { "markdown" },
        opts = {},
        name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
        dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    },
}
