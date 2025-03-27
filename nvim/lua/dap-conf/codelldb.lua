---@class CodelldbLaunchAll: dap.Configuration
---@field name string Launch configuration name, as you want it to appear in the Run and Debug panel.
---@field type string|'lldb'|'codelldb'
--- Session initiation method:
--- * `launch` to [create a new process](https://github.com/vadimcn/codelldb/blob/master/MANUAL.md#launching-a-new-process)
--- * `attach` to [attach to an already running process](https://github.com/vadimcn/codelldb/blob/master/MANUAL.md#attaching-to-a-running-process)
---@field request "launch"|"attach"
---@field initCommands? string[] LLDB commands executed upon debugger startup.
---@field targetCreateCommands? string[] LLDB commands executed to create debug target.
---@field preRunCommands? string[] LLDB commands executed just before launching of attaching to the debuggee.
---@field processCreateCommands? string[] LLDB commands executed to create/attach the debuggee process.
---@field postRunCommands? string[] LLDB commands executed just after launching or attaching to the debuggee.
---@field preTerminateCommands? string[] LLDB commands executed just before the debuggee is terminated or disconnected from.
---@field exitCommands? string[] LLDB commands executed at the end of the debugging session.
---@field expressions? string The default expression evaluator type: simple, python or native. See [Expressions](https://github.com/vadimcn/codelldb/blob/master/MANUAL.md#expressions).
---@field sourceMap? table<string,string> See [Source Path Remapping](https://github.com/vadimcn/codelldb/blob/master/MANUAL.md#source-path-remapping).
---@field relativePathBase? string Base directory used for resolution of relative source paths. Defaults to "${workspaceFolder}".
--- Specifies how source breakpoints should be set:
--- * `path` - Resolve locations using full source file path (default).
--- * `file` - Resolve locations using file name only.
---            This option may be useful in lieu of configuring sourceMap, however, note that breakpoints will be set in all files of the same name in the project.
---            For example, Rust projects often have lots of files named "mod.rs".
---@field breakpointMode? string |'path'|'file'
---@field sourceLanguages? [string] A list of source languages used in the program. This is used to enable language-specific debugger features.
---@field reverseDebugging? boolean Enable [reverse debugging](https://github.com/vadimcn/codelldb/blob/master/MANUAL.md#reverse-debugging).

---@class CodelldbConfigLaunch: CodelldbLaunchAll
---@field request 'launch'
---@field program string|fun():string
---@field cargo? string See [Cargo support](https://github.com/vadimcn/codelldb/blob/master/MANUAL.md#cargo-support).
---@field args? string|string[] Command line parameters. If this is a string, it will be split using shell-like syntax.
---@field cwd? string working directory
---@field env? table<string,string>
---@field envFile? string Path of the file to read the environment variables from. Note that env entries will override `envPath` entries.
---@field stdio? string|string[]|table<string,string> See [Stdio Redirection](https://github.com/vadimcn/codelldb/blob/master/MANUAL.md#stdio-redirection).
--- Destination for debuggee's stdio streams:
--- * `console` for DEBUG CONSOLE
--- * `integrated` (default) for VSCode integrated terminal  NOTE: in neovim is dap-ui's terminal
--- * `external` for a new terminal window
---@field terminal? string
---@field stopOnEntry? boolean Whether to stop debuggee immediately after launching.

---@class CodelldbConfigAttach:CodelldbLaunchAll
---@field request 'attach'
---@field program string
--- Process id to attach to.
--- pid may be omitted, in which case debugger will attempt to locate an already running instance of the program.
--- You may also use [${command:pickProcess} or ${command:pickMyProcess}](https://github.com/vadimcn/codelldb/blob/master/MANUAL.md#pick-process-command)
--- here to choose process interactively.
---@field pid number
---@field stopOnEntry? boolean Whether to stop debuggee immediately after launching.
---@field waitFor boolean Wait for the process to launch.

---@diagnostic disable: redundant-parameter, unused-local
local dap = require("dap")
local vfn = vim.fn

local codelldb_conf = require("public.utils").codelldb_config()

-- never showDisassembly
-- https://github.com/mfussenegger/nvim-dap/issues/307#issuecomment-929754523
dap.adapters.codelldb = codelldb_conf

local util = require("public.utils")
local git_root = util.get_root_dir(vim.uv.cwd() or ".", ".git")

local content = nil
local name

if git_root ~= nil then
    local file = io.open(git_root .. "Cargo.toml", "r")

    if file == nil then
        name = ""
    else
        content = file:read("*all")

        file:close()
        -- 查找 package name 并提取字符串
        name = string.match(content, 'name%s*=%s*"([^"]*)"')
    end
end

---@type CodelldbConfigLaunch
local rs = {
    name = "Launch file",
    type = "codelldb",
    sourceLanguages = { "rust" },
    reverseDebugging = true,
    request = "launch",
    initCommands = {
        "script import math",
    },
    -- cargo = {
    --     env = { RUSTFLAGS = "-Clinker-ld.mold" },
    --     problemMatcher = "$rustc",
    --     filter = {
    --         name = name,
    --         -- kind = "lib",
    --         kind = "bin",
    --     },
    -- },
    program = function()
        if git_root ~= nil then
            -- vim.ui.input({}, on_confirm)
            return vfn.input("Path to executable: ", git_root .. "/target/debug/", "file")
        else
            return vfn.input("Path to executable: ", vim.uv.cwd() .. "/build_rust/", "file")
        end
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    terminal = "integrated",
}
dap.configurations.rust = {
    rs,
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return vfn.input("Path to executable: ", vim.uv.cwd() .. "/build_c_cpp/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        terminal = "integrated",
        showDisassembly = "never",
    },
}

dap.configurations.c = dap.configurations.cpp

-- local xcodebuild = require("xcodebuild.dap")
-- dap.configurations.swift = {
--     {
--         name = "iOS App Debugger",
--         type = "codelldb",
--         request = "attach",
--         program = xcodebuild.get_program_path,
--         -- alternatively, you can wait for the process manually
--         -- pid = xcodebuild.wait_for_pid,
--         cwd = "${workspaceFolder}",
--         stopOnEntry = false,
--         waitFor = true,
--     },
-- }
