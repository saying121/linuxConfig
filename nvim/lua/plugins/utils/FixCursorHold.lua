return {
    "antoinemadec/FixCursorHold.nvim",
    event = "VeryLazy",
    config = function()
        vim.g.cursorhold_updatetime = 50
    end,
}
