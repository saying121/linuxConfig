local vcmd = vim.cmd

---@type LazySpec
return {
    "folke/tokyonight.nvim",
    event = "BufWinEnter",
    -- cond = false,
    config = function()
        require("tokyonight").setup({
            style = "night",
            transparent = true,
            terminal_colors = true,
            -- Background styles. Can be "dark", "transparent" or "normal"
            styles = {
                sidebars = "transparent", -- style for sidebars, see below
                floats = "transparent", -- style for floating windows
            },
        })

        vcmd.colorscheme("tokyonight")
        vcmd.colorscheme("mycolors")
    end,
}
