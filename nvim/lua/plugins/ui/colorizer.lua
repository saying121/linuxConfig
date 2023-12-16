return {
    "norcalli/nvim-colorizer.lua",
    keys = {
        "<M-c>",
    },
    cmd = {
        "ColorizerToggle",
    },
    config = function()
        -- DEFAULT_OPTIONS = {
        --     RGB = true, -- #RGB hex codes
        --     RRGGBB = true, -- #RRGGBB hex codes
        --     names = true, -- "Name" codes like Blue
        --     RRGGBBAA = false, -- #RRGGBBAA hex codes
        --     rgb_fn = false, -- CSS rgb() and rgba() functions
        --     hsl_fn = false, -- CSS hsl() and hsla() functions
        --     css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        --     css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        --     -- Available modes: foreground, background
        --     mode = "background", -- Set the display mode.foreground
        -- }
        local keymap = vim.keymap.set
        keymap("n", "<M-c>", "<cmd>ColorizerToggle<CR>", { noremap = true, silent = true })
        require("colorizer").setup({
            css = { rgb_fn = true },
            "javascript",
            html = {
                mode = "background",
            },
            vim = { mode = "background" },
        }, { mode = "background" })
    end,
}
