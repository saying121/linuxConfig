local dap = require("dap")
-- debug编译型语言, 编译参数必须设置成debug模式,如果release模式会闪退
-- 参考asynctask的设置
dap.adapters.lldb = {
    type = "executable",
    command = "lldb",
    name = "lldb",
}

dap.configurations.rust={
    {
        type = "lldb",
        name = "LLDB: Launch",
        request = "launch",
        program = function()
            local util = require("public.utils")
            -- 调用函数，传入当前工作目录和要找的文件夹作为参数
            local git_root = util.get_git_root_dir(vim.fn.getcwd(), "/.git")
            ---@diagnostic disable-next-line: redundant-parameter
            return vim.fn.input("Path to executable: ", git_root .. "/target/debug/", "file")
        end,
        -- console = "integratedTerminal",
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
    },
}
