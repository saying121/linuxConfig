local dap = require("dap")

dap.adapters.gdb = {
    type = "executable",
    command = "rust-gdb",
    args = { "-i", "dap" },
}

dap.configurations.c = {
    {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.uv.cwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
    },
}
dap.configurations.rust = {
    {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.uv.cwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
    },
}
