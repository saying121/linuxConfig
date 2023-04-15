local dap = require("dap")

dap.adapters.rust_lldb = {
    name = "rust_lldb",
    type = "executable",
    -- command = os.getenv("HOME") .. "/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-lldb", -- adjust as needed, must be absolute path
    command = vim.fn.expand("~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-lldb"),
}
dap.configurations.rust = {
    {
        name = "Launch file",
        type = "rust_lldb",
        request = "launch",
        program = function()
            local util=require("public.utils")
            -- 调用函数，传入当前工作目录和要找的文件夹作为参数
            local really_root = util.get_git_root_dir(vim.fn.getcwd(),"/.git")
            ---@diagnostic disable-next-line: redundant-parameter
            return vim.fn.input("Path to executable: ", really_root .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        -- terminal = "integrated",
        -- showDisassembly = "never",
    },
}
