local keymap = vim.keymap.set

return {
    "chrisgrieser/nvim-various-textobjs",
    -- keys = { { "v", mode = { "n" } } },
    lazy = false,
    cond = false,
    -- opts = { useDefaultKeymaps = true },
    config = function()
        require("various-textobjs").setup({ useDefaultKeymaps = true })
        keymap({ "o", "x" }, "U", function()
            require("various-textobjs").url()
        end)
        keymap("x", "L", "g_")
    end,
}
