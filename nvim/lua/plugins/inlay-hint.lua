---@type LazySpec
return {
    "saying121/interactive-inlay-hint.nvim",
    event = "LspAttach",
    config = function()
        local inter_inlay = require("interactive-inlay-hint")
        inter_inlay.setup({
            win_opts = {
                width = 80,
                height = 40,
            },
        })
        vim.keymap.set({ "n", "x" }, "<leader>SS", inter_inlay.interaction_inlay_hint)
    end,
}
