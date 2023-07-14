return {
    "navarasu/onedark.nvim",
    cond = false,
    config = function()
        vim.cmd.colorscheme("onedark")
        vim.cmd.colorscheme("mycolors")
    end,
}
