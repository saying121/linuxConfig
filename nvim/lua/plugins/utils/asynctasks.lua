---@type LazySpec
return {
    "skywind3000/asynctasks.vim",
    dependencies = {
        "akinsho/toggleterm.nvim",
        {
            "skywind3000/asyncrun.vim",
            config = function()
                vim.g.asyncrun_open = 8
                vim.g.asyncrun_save = 2 -- 会被 tasks.ini save 覆盖
                vim.g.asyncrun_bell = 0
                vim.g.asyncrun_rootmarks = { ".git", ".svn", ".root", ".project", ".hg", "Cargo.toml", "go.mod" }
            end,
        },
    },
    cmd = {
        "AsyncTask",
        "AsyncTaskList",
    },
    keys = { { "<A-r>" } },
    config = function()
        vim.g.asynctasks_term_pos = "toggleterm2"
        -- vim.g.asynctasks_term_pos = "bottom"

        vim.g.asynctasks_term_rows = 20 -- 设置纵向切割时，高度为 10
        vim.g.asynctasks_term_cols = 60 -- 设置横向切割时，宽度为 80
        vim.g.asynctasks_term_reuse = 1 -- 设置tab终端可复用
        vim.g.asynctasks_term_focus = 1 -- 1聚焦终端，0不聚焦
        -- local utils=require("public.utils")
        -- local file=get_git_root_dir(vim.fn.getcwd(), "/tasks.ini")
        vim.g.asynctasks_extra_config = {
            "~/.config/nvim/tasks/tasks.ini",
        }

        local opts, keymap = { noremap = true, silent = true }, vim.keymap.set

        keymap("n", "<A-r>", function()
            local rows = vim.fn["asynctasks#source"](math.floor(vim.go.columns * 0.5))
            vim.ui.select(rows, {
                prompt = "AsyncTask: ",
                format_item = function(item)
                    return item[1] .. " " .. item[2]
                end,
            }, function(choice)
                if choice ~= nil then
                    vim.cmd.AsyncTask({ choice[1] })
                end
            end)
        end, opts)
    end,
}
