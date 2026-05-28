---@type LazySpec
return {
    "voldikss/vim-translator",
    cmd = {
        "TranslateR",
        "TranslateW",
        "TranslateX",
    },
    keys = {
        { "<M-y>", mode = { "n", "x" }, desc = "translate" },
        -- { '<M-c>', mode = { 'n', 'v' }, desc = 'translate' },
        -- { "<M-r>", mode = { "n", "v" }, desc = "translate" },
        { "<M-x>", mode = "n", desc = "translate" },
    },
    config = function()
        -- Available: 'bing', 'google', 'haici', 'iciba'(expired), 'sdcv', 'trans', 'youdao'
        vim.g.translator_default_engines = { "google", "haici" }
        vim.g.translator_history_enable = true
        -- vim.g.translator_window_type = "preview"

        local opts = { noremap = true, silent = true }
        local keymap = vim.keymap.set
        -- Display translation in a window
        keymap({ "n", "x" }, "<M-y>", ":TranslateW<cr>", opts)
        -- Echo translation in the cmdline
        -- Replace the text with translation
        -- keymap("n", "<M-r>", "<Plug>TranslateR", opts)
        -- keymap("v", "<M-r>", "<Plug>TranslateRV", opts)
        -- Translate the text in clipboard
        keymap("n", "<M-x>", "<Plug>TranslateX", opts)

        vim.cmd([[
        nnoremap <silent><expr> <M-f> translator#window#float#has_scroll() ?
                            \ translator#window#float#scroll(1) : "\<M-f>"
        nnoremap <silent><expr> <M-b> translator#window#float#has_scroll() ?
                            \ translator#window#float#scroll(0) : "\<M-b>"
                ]])
    end,
}
