local vfn = vim.fn
local api = vim.api

---@type LazySpec
return {
    "mfussenegger/nvim-dap",
    cond = true,
    keys = {
        { "<space>b", mode = "n" },
        { "<space>B", mode = "n" },
        { "<leader>tb", mode = "n" },
        { "<leader>sc", mode = "n" },
        { "<leader>cl", mode = "n" },
    },
    -- dependencies = require("public.utils").req_lua_files_return_table("plugins/" .. "nvim-dap" .. "/dependencies"),
    config = function()
        ---@param mode string|string[]
        ---@param lhs string
        ---@param rhs string|function
        local function keymap(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true })
        end

        -- 对各个语言的配置
        require("dap-conf.python")
        -- require("dap-conf.lldb-vscode")
        require("dap-conf.codelldb")
        -- require("dap-conf.gdb")
        -- require("dap-conf.lldb")
        -----------------------------------------------------

        vfn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
        vfn.sign_define("DapBreakpointCondition", { text = " ", texthl = "", linehl = "", numhl = "" })
        vfn.sign_define("DapLogPoint", { text = " ", texthl = "", linehl = "", numhl = "" }) -- 󰍩
        -- vnf.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })
        vfn.sign_define("DapBreakpointRejected", { text = " ", texthl = "", linehl = "", numhl = "" })

        -- vnf.sign_define("DapBreakpointCondition", { text = "🐛", texthl = "", linehl = "", numhl = "" })
        -- vnf.sign_define("DapLogPoint", { text = "🇱", texthl = "", linehl = "", numhl = "" }) -- 󰍩
        vfn.sign_define("DapStopped", { text = "👉", texthl = "", linehl = "", numhl = "" })
        -- vnf.sign_define("DapBreakpointRejected", { text = "⚠️", texthl = "", linehl = "", numhl = "" }) -- ✋

        local dap, widgets = require("dap"), require("dap.ui.widgets")

        keymap("n", "<space>b", dap.toggle_breakpoint)
        keymap("n", "<space>B", function()
            dap.set_breakpoint(vfn.input("Condition: "), vfn.input("Hit condition: "), vfn.input("Log message: "))
        end)
        keymap("n", "<space>lp", function()
            dap.set_breakpoint(nil, nil, vfn.input("Log point message: "))
        end)

        keymap({ "n", "i", "t" }, "<F1>", dap.continue)
        keymap({ "n", "i", "t" }, "<F2>", dap.step_over)
        keymap({ "n", "i", "t" }, "<F3>", dap.step_into)
        keymap({ "n", "i", "t" }, "<F4>", dap.step_out)
        keymap({ "n", "i", "t" }, "<F5>", dap.step_back)
        keymap({ "n", "i", "t" }, "<F6>", dap.run_last)
        keymap({ "n", "i", "t" }, "<F7>", dap.terminate)
        keymap({ "n", "i", "t" }, "<F8>", dap.pause)
        keymap({ "n", "i", "t" }, "<F9>", dap.disconnect)
        keymap({ "n", "i", "t" }, "<leader>rtc", dap.run_to_cursor)
        keymap("n", "<space>dr", dap.repl.open)

        keymap("n", "<Leader>df", function()
            widgets.centered_float(widgets.frames)
        end)
        keymap("n", "<Leader>ds", function()
            widgets.centered_float(widgets.scopes)
        end)
        keymap("n", "<Leader>dx", function()
            widgets.centered_float(widgets.threads)
        end)
        keymap("n", "<Leader>de", function()
            widgets.centered_float(widgets.sessions)
        end)

        local pbp = require("persistent-breakpoints.api")

        pbp.load_breakpoints()

        -- 自动开启ui
        dap.listeners.after.event_initialized["dapui_config"] = function()
            local dapui = require("dapui")
            dapui.open()
            api.nvim_command("DapVirtualTextEnable")
            _G.dapui_for_K = true
        end

        dap.listeners.before.event_terminated["dapui_config"] = function()
            api.nvim_command("DapVirtualTextEnable")
            pbp.store_breakpoints()
            _G.dapui_for_K = false
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            api.nvim_command("DapVirtualTextEnable")
            pbp.store_breakpoints()
            _G.dapui_for_K = false
        end
        dap.listeners.before.disconnect["dapui_config"] = function()
            api.nvim_command("DapVirtualTextEnable")
            pbp.store_breakpoints()
            _G.dapui_for_K = false
        end

        dap.defaults.fallback.focus_terminal = false
        dap.defaults.fallback.force_external_terminal = false
    end,
}
