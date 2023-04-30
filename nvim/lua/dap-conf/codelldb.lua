local dap = require("dap")

dap.adapters.codelldb = {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
        command = "codelldb",
        -- args = { "--liblldb", liblldb_path, "--port", "${port}" },
        args = { "--port", "${port}" },
        -- On windows you may have to uncomment this:
        -- detached = false,
    },
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            ---@diagnostic disable-next-line: redundant-parameter
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build_c_cpp/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        terminal = "integrated",
    },
}

dap.configurations.c = dap.configurations.cpp

--- rust 在调试时会出 bug
-- [issue 链接]( https://github.com/vadimcn/codelldb/issues/251 )
dap.configurations.rust = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            local util = require("public.utils")
            -- 调用函数，传入当前工作目录和要找的文件夹作为参数
            local git_root = util.get_git_root_dir(vim.fn.getcwd(), "/.git")
            ---@diagnostic disable-next-line: redundant-parameter
            return vim.fn.input("Path to executable: ", git_root .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        terminal = "integrated",
        -- showDisassembly = "never",
    },
}
