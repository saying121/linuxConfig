local dap = require("dap")

dap.adapters.python = {
    type = "executable",
    command = "/bin/python3",
    args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = { -- launch exe
    {
        type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = "launch",
        name = "Launch file",
        program = "${file}", -- This configuration will launch the current file if used.
        console = "integratedTerminal",
        -- args = function()
        --     local input = vim.fn.input("Input args: ")
        --     return require("user.dap.dap-util").str2argtable(input)
        -- end,
        pythonPath = function()
            local venv_path = vim.env.VIRTUAL_ENV
            if venv_path then
                return venv_path .. "/bin/python"
            end
            return "/usr/bin/python3"
        end,
    },
}
