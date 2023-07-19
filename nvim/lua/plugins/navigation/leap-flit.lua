return {
    "ggandor/leap.nvim",
    -- cond = false,
    keys = {
        -- { "<M-o>", mode = { "x", "o", "n" } },
        -- { "<M-O>", mode = { "x", "o", "n" } },
        { "gm", mode = { "x", "o", "n" } },
        -- { "gw", mode = { "x", "o", "n" } },
        { "x", mode = { "x", "o" } },
        { "x", mode = { "x", "o" } },
        { "f" },
        { "F" },
    },
    dependencies = {
        {
            "ggandor/flit.nvim",
            config = function()
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
        },
    },
    config = function()
        local opts = { noremap = true, silent = true }
        local keymap = vim.keymap.set
        -- keymap({ "n", "x", "o" }, "<M-o>", "<Plug>(leap-forward-to)", opts)
        -- keymap({ "n", "x", "o" }, "<M-O>", "<Plug>(leap-backward-to)", opts)
        keymap({ "x", "o" }, "x", "<Plug>(leap-forward-till)", opts)
        keymap({ "x", "o" }, "X", "<Plug>(leap-backward-till)", opts)
        keymap({ "n", "x", "o" }, "gm", "<Plug>(leap-from-window)", opts)
        -- keymap({ "n", "x", "o" }, "gw", "<Plug>(leap-cross-window)", opts)
    end,
}
