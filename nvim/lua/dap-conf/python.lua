local dap = require("dap")

dap.adapters.python = {
    type = "executable",
    command = "/bin/python3",
    args = { "-m", "debugpy.adapter" },
}
-- dap.configurations.python = {
--     {
--         -- The first three options are required by nvim-dap
--         type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
--         request = 'launch',
--         name = "Launch file",
--
--         -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
--
--         program = "${file}", -- This configuration will launch the current file if used.
--         pythonPath = function()
--             -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
--             -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
--             -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
--             local cwd = vim.fn.getcwd()
--             if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
--                 return cwd .. '/venv/bin/python3'
--             elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
--                 return cwd .. '/.venv/bin/python3'
--             else
--                 return '/usr/bin/python3'
--             end
--         end,
--     },
-- }

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
            local venv_path = os.getenv("VIRTUAL_ENV")
            if venv_path then
                return venv_path .. "/bin/python"
            end
            return "/usr/bin/python3"
        end,
    },
}
