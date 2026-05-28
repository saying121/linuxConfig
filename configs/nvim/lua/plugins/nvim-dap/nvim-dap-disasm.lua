---@type LazySpec
return {
    "Jorenar/nvim-dap-disasm",
    dependencies = "igorlfs/nvim-dap-view",
    opts = {
        dapview_register = true,
        dapview = {
            keymap = "D",
            label = " [D]",
            short_label = " [D]",
        },
    },
}
