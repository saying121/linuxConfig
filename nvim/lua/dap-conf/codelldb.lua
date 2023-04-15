local dap = require("dap")

-- local extension_path = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/codelldb/extension/"
local extension_path = os.getenv("HOME") .. "/.vscode/extensions/vadimcn.vscode-lldb-1.9.0/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

dap.adapters.codelldb = {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
        -- command = os.getenv("HOME") .. "/.vscode/extensions/vadimcn.vscode-lldb-1.9.0/adapter/codelldb",
        command = codelldb_path,
        -- args = { "--liblldb", liblldb_path, "--port", "${port}" },
        args = { "--liblldb", liblldb_path, "--port", "${port}" },
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
            local util=require("public.utils")
            -- 调用函数，传入当前工作目录和要找的文件夹作为参数
            local really_root = util.get_git_root_dir(vim.fn.getcwd(),"/.git")
            ---@diagnostic disable-next-line: redundant-parameter
            return vim.fn.input("Path to executable: ", really_root .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        terminal = "integrated",
        -- showDisassembly = "never",
    },
}
