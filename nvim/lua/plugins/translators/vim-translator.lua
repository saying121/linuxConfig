return {
    "voldikss/vim-translator",
    lazy = true,
    keys = {
        { "<M-y>", mode = { "n", "v" }, desc = "translate" },
        -- { '<M-c>', mode = { 'n', 'v' }, desc = 'translate' },
        { "<M-r>", mode = { "n", "v" }, desc = "translate" },
        { "<M-x>", mode = "n", desc = "translate" },
    },
    config = function()
        -- Available: 'bing', 'google', 'haici', 'iciba'(expired), 'sdcv', 'trans', 'youdao'
        vim.g.translator_default_engines = { "google", "haici" }
        local opts = { noremap = true, silent = true }
        local keymap = vim.api.nvim_set_keymap
        -- Display translation in a window
        keymap("n", "<M-y>", "<Plug>TranslateW", opts)
        keymap("v", "<M-y>", "<Plug>TranslateWV", opts)
        -- Echo translation in the cmdline
        -- vim.api.nvim_set_keymap('n', '<M-c>', '<Plug>Translate', opts)
        -- vim.api.nvim_set_keymap('v', '<M-c>', '<Plug>TranslateV', opts)
        -- Replace the text with translation
        keymap("n", "<M-r>", "<Plug>TranslateR", opts)
        keymap("v", "<M-r>", "<Plug>TranslateRV", opts)
        -- Translate the text in clipboard
        keymap("n", "<M-x>", "<Plug>TranslateX", opts)
    end,
}
