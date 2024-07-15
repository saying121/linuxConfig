---@type LazySpec
return {
    "saying121/input-switch.nvim",
    dev = true,
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
        require("input-switch").setup({
            switch_to_en = "fcitx5-remote -c",
            switch_no_en = "fcitx5-remote -o",
            comment = false,
        })
    end,
}
