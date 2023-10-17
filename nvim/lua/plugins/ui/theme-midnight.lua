return {
    "dasupradyumna/midnight.nvim",
    event = "BufWinEnter",
    cond = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("midnight")
        vim.cmd.colorscheme("mycolors")
    end,
}
