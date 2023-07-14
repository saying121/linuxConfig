return {
    "nvimdev/zephyr-nvim",
    event = "BufWinEnter",
    cond = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        vim.cmd.colorscheme("zephyr")
        vim.cmd.colorscheme("mycolors")
    end,
}
