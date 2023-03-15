return {
    "mfussenegger/nvim-dap",
    lazy = true,
    -- event = 'VimEnter',
    keys = require("plugins.daps.the_keys"),
    cmd = {
        "PBToggleBreakpoint",
        "PBClearAllBreakpoints",
        "PBSetConditionalBreakpoint",
    },
    config = function()
        -- 对各个语言的配置
        require("dap-conf.python")
        require("dap-conf.c")
        -- ---------------------------------------------------

        vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })

        local dap = require("dap")
        local keymap = vim.keymap.set
        local opts = { noremap = true, silent = true }

        keymap("n", "<space>b", dap.toggle_breakpoint, opts)
        keymap(
            "n",
            "<space>B",
            "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
            opts
        )

        keymap({ "n", "i", "t" }, "<F5>", dap.continue, opts)
        keymap({ "n", "i", "t" }, "<F6>", dap.step_into, opts)
        keymap({ "n", "i", "t" }, "<F7>", dap.step_over, opts)
        keymap({ "n", "i", "t" }, "<F8>", dap.step_out, opts)
        keymap({ "n", "i", "t" }, "<F9>", dap.step_back, opts)
        keymap({ "n", "i", "t" }, "<F10>", dap.run_last, opts)
        keymap({ "n", "i", "t" }, "<F11>", dap.terminate, opts)

        keymap(
            "n",
            "<space>lp",
            "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
            opts
        )
        keymap("n", "<space>dr", dap.repl.open, opts)
        keymap("n", "<space>dl", dap.run_last, opts)

        -- local dap = require('dap')
        local dapui = require("dapui")
        -- 自动开启ui
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
            vim.api.nvim_command("DapVirtualTextEnable")
            vim.opt.laststatus = 2
        end
        -- 自动关闭ui
        dap.listeners.before.event_terminated["dapui_config"] = function()
            vim.api.nvim_command("DapVirtualTextEnable")
            -- dapui.close()
            vim.opt.laststatus = 3
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            vim.api.nvim_command("DapVirtualTextEnable")
            -- dapui.close()
            vim.opt.laststatus = 3
        end
        dap.listeners.before.disconnect["dapui_config"] = function()
            vim.api.nvim_command("DapVirtualTextEnable")
            -- dapui.close()
            vim.opt.laststatus = 3
        end
        -- TODO wait dap-ui for fix terminal layout
        -- dap.defaults.fallback.terminal_win_cmd = 'set splitright | 10vsplit new' -- this will be override by dapui
        -- dap.defaults.python.terminal_win_cmd = 'set splitright | 2vsplit new' -- 终端会被移动，这个数值不准确
        dap.defaults.fallback.focus_terminal = false
        dap.defaults.fallback.force_external_terminal = false
    end,
}
