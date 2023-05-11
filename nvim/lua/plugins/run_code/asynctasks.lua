return {
    "skywind3000/asynctasks.vim",
    dependencies = {
        "skywind3000/asyncrun.vim",
        "akinsho/toggleterm.nvim",
    },
    cmd = {
        "AsyncTask",
        "AsyncTaskList",
    },
    keys = {
        { "<F4>" },
        { "<F3>" },
        { "<A-b>" },
        { "<A-r>" },
    },
    config = function()
        vim.g.asyncrun_open = 6
        vim.g.asynctasks_term_pos = "toggleterm2"
        -- vim.g.asynctasks_term_pos = "bottom"
        vim.g.asynctasks_term_rows = 20 -- 设置纵向切割时，高度为 10
        vim.g.asynctasks_term_cols = 60 -- 设置横向切割时，宽度为 80
        vim.g.asynctasks_term_reuse = 1 -- 设置tab终端可复用
        vim.g.asynctasks_term_focus = 1 -- 1聚焦终端，0不聚焦
        vim.g.asynctasks_extra_config = {
            "~/.config/nvim/tasks.ini",
        }
        vim.g.asyncrun_rootmarks = { ".git", ".svn", ".root", ".project", ".hg" }

        local opts, keymap = { noremap = true, silent = true }, vim.keymap.set
        keymap("n", "<F3>", ":AsyncTask file-build<CR>", opts)
        keymap("n", "<F4>", ":AsyncTask file-run<CR>", opts)

        keymap("n", "<A-b>", ":AsyncTask project-build<CR>", opts)
        keymap("n", "<A-r>", ":AsyncTask project-run<CR>", opts)
    end,
}
