return {
    "folke/tokyonight.nvim",
    -- priority = 1000,
    -- cond = true,
    config = function()
        vim.cmd.colorscheme("tokyonight")
        vim.cmd.colorscheme("plugcolors")

        require("tokyonight").setup({
            style = "night",
            transparent = false,
            terminal_colors = true,
            -- Background styles. Can be "dark", "transparent" or "normal"
            styles = {
                sidebars = "normal", -- style for sidebars, see below
                floats = "normal", -- style for floating windows
            },
        })
    end,
}
