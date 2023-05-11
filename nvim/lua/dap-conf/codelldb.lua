---@diagnostic disable: redundant-parameter
local dap = require("dap")

dap.adapters.codelldb = {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
        command = "codelldb",
        -- args = { "--liblldb", liblldb_path, "--port", "${port}" },
        args = { "--port", "${port}" },
        -- args = { "--port", "${port}", "--params", [[{"showDisassembly" : "never"}]] },
        -- On windows you may have to uncomment this:
        -- detached = false,
    },
}

local util = require("public.utils")
-- 调用函数，传入当前工作目录和要找的文件夹作为参数
local git_root = util.get_git_root_dir(vim.fn.getcwd(), "/.git")
local content = nil
---@diagnostic disable-next-line: unused-local
local name

if git_root ~= nil then
    local file = io.open(git_root .. "Cargo.toml", "r")

    if file == nil then
        ---@diagnostic disable-next-line: unused-local
        name = ""
    else
        content = file:read("*all")

        file:close()
        -- 查找 package name 并提取字符串
        ---@diagnostic disable-next-line: unused-local
        name = string.match(content, 'name%s*=%s*"([^"]*)"')
    end
end

-- 不显示反汇编只能在vscode设置
-- https://github.com/mfussenegger/nvim-dap/issues/307#issuecomment-929754523
dap.configurations.rust = {
    {
        name = "Launch file",
        type = "codelldb",
        sourceLanguages = { "rust" },
        reverseDebugging = true,
        request = "launch",
        -- showDisassembly = "never",
        -- cargo = {
        --     env = { RUSTFLAGS = "-Clinker-ld.mold" },
        --     problemMatcher = "$rustc",
        --     filter = {
        --         name = name,
        --         -- kind = "lib",
        --         kind = "bin",
        --     },
        -- },
        -- program = "${workspaceFolder}/target/debug/" .. string.match(vim.lsp.buf.list_workspace_folders()[1], "[^/]+$"),
        program = function()
            if git_root ~= nil then
                return vim.fn.input("Path to executable: ", git_root .. "/target/debug/", "file")
            else
                return vim.fn.input("Path to executable: ", "./build_rust/", "file")
                -- return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build_rust/", "file")
            end
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        terminal = "integrated",
    },
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build_c_cpp/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        terminal = "integrated",
        showDisassembly = "never",
    },
}

dap.configurations.c = dap.configurations.cpp
