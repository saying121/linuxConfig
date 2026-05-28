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
            ui_select = true,
            disable_when = function(hint_list)
                for _, v in ipairs(hint_list) do
                    if type(v.inlay_hint.label) == "table" then
                        return false
                    end
                end
                return true
            end,
        })
        vim.keymap.set({ "n", "x" }, "<leader>SS", inter_inlay.interaction_inlay_hint)
    end,
}
