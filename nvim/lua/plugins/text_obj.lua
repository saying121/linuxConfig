return {
    "chrisgrieser/nvim-various-textobjs",
    -- keys = { { "v", mode = { "n" } } },
    lazy = false,
    opts = { useDefaultKeymaps = true },
    config = function()
        vim.keymap.set({ "o", "x" }, "U", function()
            require("various-textobjs").url()
        end)
    end,
}
