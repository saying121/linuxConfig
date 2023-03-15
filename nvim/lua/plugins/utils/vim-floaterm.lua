return {
    "voldikss/vim-floaterm",
    lazy = true,
    keys = {
        { "<space>tt", mode = "n", desc = "floaterm" },
        { "<space>tr", mode = "n", desc = "float ranger" },
    },
    cmd = { "FloatermNew" },
    -- ft = 'dashboard',
    config = function()
        local opts = { noremap = true, silent = true }
        local keymap = vim.api.nvim_set_keymap
        keymap("n", "<space>tt", ":FloatermNew --height=0.8 --width=0.8<CR>", opts)
        keymap("n", "<space>tr", ":FloatermNew --height=0.8 --width=0.8 ranger<CR>", opts)
        keymap("n", "<space>to", ":FloatermToggle<CR>", opts)
        keymap("n", "<space>ki", ":FloatermKill<CR>", opts)
        keymap("n", "<space>pr", ":FloatermPrev<CR>", opts)
        keymap("n", "<space>ne", ":FloatermNext<CR>", opts)
    end,
}
