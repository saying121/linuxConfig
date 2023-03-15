return {
    "skywind3000/asynctasks.vim",
    dependencies = {
        "skywind3000/asyncrun.vim",
    },
    keys = {
        { "<F4>" },
        { "<F3>" },
    },
    config = function()
        vim.g.asyncrun_open = 6
        -- quickfix	伪终端	默认值，使用 quickfix 窗口模拟终端，输出不匹配 errorformat。
        -- vim	    -	        传统 vim 的 ! 命令运行任务
        -- tab  	内置终端	在一个新的 tab 上打开内置终端，运行程序。
        -- TAB  	内置终端	同 tab 但是是在左边打开，关闭后方便回到上一个 tab
        -- top  	内置终端	在上方打开可复用内部终端。
        -- bottom	内置终端	在下方打开可复用内部终端。
        -- left 	内置终端	在左边打开可复用内置终端。
        -- right	内置终端	在右边打开可复用内置终端。
        -- external	外部终端	启动一个新的操作系统的外置终端窗口，运行程序。
        vim.g.asynctasks_term_pos = "right"
        vim.g.asynctasks_term_rows = 10 -- 设置纵向切割时，高度为 10
        vim.g.asynctasks_term_cols = 60 -- 设置横向切割时，宽度为 80
        vim.g.asynctasks_term_reuse = 1 -- 设置tab终端可复用
        vim.g.asynctasks_term_focus = 1 -- 1聚焦终端，0不聚焦
        local opts = { noremap = true, silent = true }
        vim.api.nvim_set_keymap("n", "<F4>", ":AsyncTask file-run<CR>", opts)
        vim.api.nvim_set_keymap("n", "<F3>", ":AsyncTask file-build<CR>", opts)
    end,
}
