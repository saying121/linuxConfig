---@type LazySpec
return {
    "saying121/input-switch.nvim",
    -- cond=false,
    dev = false,
    -- event = { "InsertEnter", "CmdlineEnter" },
    config = function()
        require("input-switch").setup({
            comment = false,
        })
    end,
}
