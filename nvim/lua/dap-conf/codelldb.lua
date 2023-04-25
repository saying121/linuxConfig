local dap = require("dap")

-- local extension_path = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/codelldb/extension/"
-- local codelldb_path = extension_path .. "adapter/codelldb"
-- local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

dap.adapters.codelldb = {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
        -- command = codelldb_path,
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
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        terminal = "integrated",
    },
}

dap.configurations.c = dap.configurations.cpp

-- rust 在调试时会出 bug
-- https://github.com/vadimcn/codelldb/issues/251
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
