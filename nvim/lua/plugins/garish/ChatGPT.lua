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
            chat = {
                -- welcome_message = WELCOME_MESSAGE,
                loading_text = "Loading, please wait ...",
                question_sign = "",
                answer_sign = "ﮧ",
                max_line_length = 120,
                sessions_window = {
                    border = {
                        style = "rounded",
                        text = {
                            top = " Sessions ",
                        },
                    },
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                },
                keymaps = {
                    close = { "<C-c>" },
                    yank_last = "<C-y>",
                    yank_last_code = "<C-k>",
                    scroll_up = "<C-u>",
                    scroll_down = "<C-d>",
                    new_session = "<C-n>",
                    cycle_windows = "<Tab>",
                    cycle_modes = "<C-f>",
                    select_session = "<Space>",
                    rename_session = "r",
                    delete_session = "d",
                    draft_message = "<C-m>",
                    toggle_settings = "<C-o>",
                    toggle_message_role = "<C-r>",
                    toggle_system_role_open = "<C-s>",
                },
            },
        })
    end,
}
