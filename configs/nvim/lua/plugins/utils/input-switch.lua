---@type LazySpec
return {
    {
        "saying121/input-switch.nvim",
        dev = false,
        cond = function()
            return vim.uv.os_uname().sysname ~= "Darwin"
        end,
        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            require("input-switch").setup({
                switch_to_en = "fcitx5-remote -c",
                switch_no_en = "fcitx5-remote -o",
                comment = false,
            })
        end,
    },
    {
        "keaising/im-select.nvim",
        cond = function()
            return vim.uv.os_uname().sysname == "Darwin"
        end,
        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            require("im_select").setup({})
        end,
    },
}
