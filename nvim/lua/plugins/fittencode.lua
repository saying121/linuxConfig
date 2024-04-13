return {
    "luozhiya/fittencode.nvim",
    cond = false,
    event = { "InsertEnter" },
    config = function()
        require("fittencode").setup({
            completion_mode = "source",
        })
    end,
}
