local dap = require("dap")

local function get_python()
    local cwd = vim.uv.cwd()
    local virtualenv = vim.fn.getenv("VIRTUAL_ENV")

    if virtualenv ~= vim.NIL and virtualenv ~= "" then
        return virtualenv .. "/bin/python"
    elseif vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
        return cwd .. "/venv/bin/python"
    elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
        return cwd .. "/.venv/bin/python"
    end

    return "/usr/bin/python"
end

dap.adapters.python = {
    type = "executable",
    command = get_python(),
    args = { "-m", "debugpy.adapter" },
    options = {
        source_filetype = "python",
    },
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
        pythonPath = get_python(),
    },
}
