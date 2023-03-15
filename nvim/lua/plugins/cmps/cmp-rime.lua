return {
    "yao-weijie/cmp-rime",
    -- cond = false,
    config = function()
        require("cmp_rime").setup({
            -- linux/mac用户只需要从软件源中安装rime
            -- windows用户可能需要指定librime.dll路径, 没测试过
            libpath = "/lib64/librime.so",
            traits = {
                -- windows 用户的在小狼毫的程序文件夹
                shared_data_dir = "/usr/share/rime-data",
                -- 最好新建一个独立的用户目录, 否则很有可能出问题
                user_data_dir = vim.fn.expand("~/.local/share/cmp-rime"),
                log_dir = "/tmp/cmp-rime",
            },
            enable = {
                global = true, -- 全局开启, 不建议
                comment = true, -- 总是在comment中开启
                -- 其他情况手动开关
            },
            preselect = false, -- 预选中rime 返回的第一项,可以直接空格上屏
            auto_commit = false, -- 五笔/音形类方案可用, 唯一候选项自动上屏
            number_select = 5, -- 映射1-5为数字选词, 最大支持到9, 0表示禁用
        })
        vim.keymap.set({ "i" }, "<C-g>", function()
            require("cmp_rime").mapping.toggle()
        end, { desc = "toggle rime" })
    end,
}
