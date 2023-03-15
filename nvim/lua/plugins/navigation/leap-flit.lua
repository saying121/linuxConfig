return {
    "ggandor/leap.nvim",
    lazy = true,
    keys = {
        { "m", mode = { "x", "o", "n" } },
        { "M", mode = { "x", "o", "n" } },
        { "f" },
        { "F" },
    },
    dependencies = {
        {
            "ggandor/flit.nvim",
            lazy = true,
            keys = { { "f" }, { "F" } },
        },
    },
    config = function()
        local opts = { noremap = true, silent = true }
        vim.keymap.set({ "x", "o", "n" }, "gm", "<Plug>(leap-cross-window)", opts)
        require("flit").setup({
            keys = { f = "f", F = "F", t = "t", T = "T" },
            -- A string like "nv", "nvo", "o", etc.
            labeled_modes = "v",
            multiline = true,
            -- Like `leap`s similar argument (call-specific overrides).
            -- E.g.: opts = { equivalence_classes = {} }
            opts = {},
        })
    end,
}
