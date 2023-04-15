local dap = require("dap")

dap.adapters.lldb = {
    type = "executable",
    command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
    name = "lldb",
}
dap.configurations.cpp = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            ---@diagnostic disable-next-line: redundant-parameter
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        -- preRunCommands='',
        args = {},
        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --
        -- But you should be aware of the implications:
        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        runInTerminal = true,
    },
}
-- If you want to use this for Rust and C, add something like this:

dap.configurations.c = dap.configurations.cpp

dap.configurations.rust = dap.configurations.cpp
dap.configurations.rust[1]["program"] = function()
    local util = require("public.utils")
    -- 调用函数，传入当前工作目录和要找的文件夹作为参数
    local really_root = util.get_git_root_dir(vim.fn.getcwd(), "/.git")
    ---@diagnostic disable-next-line: redundant-parameter
    return vim.fn.input("Path to executable: ", really_root .. "/target/debug/", "file")
end
