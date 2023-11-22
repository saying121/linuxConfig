return {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    ft = "swift",
    config = function()
        local xcodebuild = require("xcodebuild.dap")

        vim.keymap.set("n", "<leader>dd", xcodebuild.build_and_debug, { desc = "Build & Debug" })
        vim.keymap.set("n", "<leader>dr", xcodebuild.debug_without_build, { desc = "Debug Without Building" })

        -- Lua
        vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
        vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
        vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })
        vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
        vim.keymap.set("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run This Test Class" })
        vim.keymap.set("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Show All Xcodebuild Actions" })
        vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
        vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
        vim.keymap.set("n", "<leader>xq", "<cmd>Telescope quickfix<cr>", { desc = "Show QuickFix List" })

        require("xcodebuild").setup({
            restore_on_start = true, -- logs, diagnostics, and marks will be loaded on VimEnter (may affect performance)
            auto_save = true, -- save all buffers before running build or tests (command: silent wa!)
            show_build_progress_bar = true, -- shows [ ...    ] progress bar during build, based on the last duration
            commands = {
                extra_build_args = "-parallelizeTargets", -- extra arguments for `xcodebuild build`
                extra_test_args = "-parallelizeTargets", -- extra arguments for `xcodebuild test`
            },
            logs = {
                auto_open_on_success_tests = true, -- open logs when tests succeeded
                auto_open_on_failed_tests = true, -- open logs when tests failed
                auto_open_on_success_build = true, -- open logs when build succeeded
                auto_open_on_failed_build = true, -- open logs when build failed
                auto_close_on_app_launch = false, -- close logs when app is launched
                auto_close_on_success_build = false, -- close logs when build succeeded (only if auto_open_on_success_build=false)
                auto_focus = true, -- focus logs buffer when opened
                filetype = "objc", -- file type set for buffer with logs
                open_command = "silent bo split {path} | resize 20", -- command used to open logs panel. You must use {path} variable to load the log file
                logs_formatter = "xcbeautify --disable-colored-output", -- command used to format logs, you can use "" to skip formatting
                only_summary = false, -- if true logs won't be displayed, just xcodebuild.nvim summary
                show_warnings = true, -- show warnings in logs summary
                notify = function(message, severity) -- function to show notifications from this module (like "Build Failed")
                    vim.notify(message, severity)
                end,
                notify_progress = function(message) -- function to show live progress (like during tests)
                    vim.cmd("echo '" .. message .. "'")
                end,
            },
            marks = {
                show_signs = true, -- show each test result on the side bar
                success_sign = "✔", -- passed test icon
                failure_sign = "✖", -- failed test icon
                success_sign_hl = "DiagnosticSignOk", -- highlight for success_sign
                failure_sign_hl = "DiagnosticSignError", -- highlight for failure_sign
                show_test_duration = true, -- show each test duration next to its declaration
                success_test_duration_hl = "DiagnosticWarn", -- test duration highlight when test passed
                failure_test_duration_hl = "DiagnosticError", -- test duration highlight when test failed
                show_diagnostics = true, -- add test failures to diagnostics
                file_pattern = "*Tests.swift", -- test diagnostics will be loaded in files matching this pattern (if available)
            },
            quickfix = {
                show_errors_on_quickfixlist = true, -- add build/test errors to quickfix list
                show_warnings_on_quickfixlist = true, -- add build warnings to quickfix list
            },
        })
    end,
}
