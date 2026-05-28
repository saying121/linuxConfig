---@type LazySpec
return {
    "xzbdmw/colorful-menu.nvim",
    lazy = true,
    -- Shit, the plug need load befor blink.cmp, priority not work
    -- file name add "a" prefix
    priority = 2000,
    opts = {
        ls = {
            ["rust-analyzer"] = {
                -- Similar to the same setting of gopls.
                align_type_to_right = false,
            },
        },
    },
}
