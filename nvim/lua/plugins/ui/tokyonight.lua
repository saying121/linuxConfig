return {
    "folke/tokyonight.nvim",
    priority = 2000,
    event = "BufWinEnter",
    -- cond = true,
    config = function()
        require("tokyonight").setup({
            style = "night",
            transparent = true,
            terminal_colors = true,
            -- Background styles. Can be "dark", "transparent" or "normal"
            styles = {
                sidebars = "normal", -- style for sidebars, see below
                floats = "normal", -- style for floating windows
            },
        })

        vim.cmd.colorscheme("tokyonight")
        vim.cmd.colorscheme("plugcolors")
    end,
}
