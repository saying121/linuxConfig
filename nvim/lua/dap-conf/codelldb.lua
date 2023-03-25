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
            -- 定义一个函数，接受一个目录作为参数
            local function get_git_root(dir, be_find)
                -- 使用vim.loop.fs_stat检查目录是否存在
                local stat = vim.loop.fs_stat(dir)
                -- 如果不存在，返回nil
                if not stat then
                    return nil
                end
                -- 如果存在，拼接.git目录的路径
                local git_dir = dir .. be_find
                -- 使用vim.loop.fs_stat检查.git目录是否存在
                local git_stat = vim.loop.fs_stat(git_dir)
                -- 如果存在，返回当前目录
                if git_stat then
                    return dir
                end
                -- 如果不存在，获取上一级目录的路径
                local parent_dir = vim.fn.fnamemodify(dir, ":h")
                -- 如果上一级目录和当前目录相同，说明已经到达根目录，返回nil
                if parent_dir == dir then
                    return nil
                end
                -- 否则，递归调用函数，传入上一级目录作为参数
                return get_git_root(parent_dir, be_find)
            end

            -- 调用函数，传入当前工作目录和要找的文件夹作为参数
            local really_root = get_git_root(vim.fn.getcwd(), "/.git")
            ---@diagnostic disable-next-line: redundant-parameter
            return vim.fn.input("Path to executable: ", really_root .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        terminal = "integrated",
        -- showDisassembly = "never",
    },
}
