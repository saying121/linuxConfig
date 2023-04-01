return {
    "jackMort/ChatGPT.nvim",
    keys = {
        { "zf", mode = "n" },
    },
    cmd = {
        "ChatGPT",
        "ChatGPTActAs",
        "ChatGPTRun",
        "ChatGPTRunCustomCodeAction",
        "ChatGPTCompleteCode",
        "ChatGPTEditWithInstructions",
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        vim.keymap.set("n", "zf", ":ChatGPT<CR>", { silent = true, noremap = true })
        -- require("chatgpt").setup()
        require("chatgpt").setup({
            welcome_message = "ﮧ",
            keymaps = {
                close = { "<C-c>" },
                submot = "<C-Enter>",
                yank_last = "<C-y>",
                scroll_up = "<C-u>",
                scroll_down = "<C-d>",
                toggle_settings = "<C-o>",
                new_session = "<C-n>",
                cycle_windows = "<Tab>",
                -- in the Sessions pane
                select_session = "<cr>",
                rename_session = "r",
                delete_session = "dd",
            },
        })
    end,
}
