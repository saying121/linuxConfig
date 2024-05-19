local api = vim.api
local vfn = vim.fn
---@type LazySpec
return {
    "nvim-neotest/neotest",
    keys = {
        { "<leader>tf", mode = { "n" } },
        { "<leader>tr", mode = { "n" } },
        { "<leader>tg", mode = { "n" } },
        { "<leader>to", mode = { "n" } },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        {
            "rouge8/neotest-rust",
            build = '[[ "$(command -v cargo-nextest)" = "" ]] && cargo install cargo-nextest',
        },
        "nvim-neotest/neotest-python",
    },
    config = function()
        local nt = require("neotest")

        local keymap, opts = vim.keymap.set, { silent = true, noremap = true }

        keymap("n", "<leader>tf", function()
            nt.run.run(vfn.expand("%"))
        end, opts)

        keymap("n", "<leader>tr", function()
            nt.run.run()
        end, opts)

        keymap("n", "<leader>ts", function()
            nt.run.stop()
        end, opts)

        keymap("n", "<leader>tg", function()
            nt.summary.toggle()
        end, opts)

        keymap("n", "<leader>to", function()
            nt.output.open({ enter = true, auto_close = true })
        end, opts)

        keymap("n", "]t", function()
            nt.jump.next({ status = "failed" })
        end, opts)

        keymap("n", "[t", function()
            nt.jump.prev({ status = "failed" })
        end, opts)

        api.nvim_create_autocmd({ "FileType" }, {
            group = api.nvim_create_augroup("NeotestKeyMap", { clear = true }),
            pattern = { "neotest-output" },
            callback = function()
                local opts1 = { silent = true, noremap = true, buffer = true }
                keymap("n", "q", ":x<CR>", opts1)
            end,
        })

        local adapters = {
            require("neotest-rust")({
                -- args = { "--no-capture" },
                dap_adapter = "lldb",
            }),
            require("neotest-python")({
                -- Extra arguments for nvim-dap configuration
                -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
                dap = { justMyCode = false },
                -- Command line arguments for runner
                -- Can also be a function to return dynamic values
                args = { "--log-level", "DEBUG" },
                -- Runner to use. Will use pytest if available by default.
                -- Can be a function to return dynamic value.
                runner = "pytest",
                -- Custom python path for the runner.
                -- Can be a string or a list of strings.
                -- Can also be a function to return dynamic value.
                -- If not provided, the path will be inferred by checking for
                -- virtual envs in the local directory and for Pipenev/Poetry configs
                python = ".venv/bin/python",
                -- Returns if a given file path is a test file.
                -- NB: This function is called a lot so don't perform any heavy tasks within it.
                -- is_test_file = function(file_path)
                -- end,
            }),
        }
        local summ_map = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            debug = "d",
            debug_marked = "D",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "s",
            target = "t",
        }

        local config = {
            adapters = adapters,
            benchmark = {
                enabled = true,
            },
            consumers = {},
            default_strategy = "integrated",
            diagnostic = {
                enabled = true,
                severity = 1,
            },
            discovery = {
                concurrent = 0,
                enabled = true,
            },
            floating = {
                border = "rounded",
                max_height = 0.6,
                max_width = 0.6,
                options = {},
            },
            icons = {
                collapsed = "─",
                failed = "",
                final_child_indent = " ",
                final_child_prefix = "╰",
                non_collapsible = "─",
                passed = "",
                running = "",
                skipped = "",
                unknown = "",
            },
            jump = {
                enabled = true,
            },
            log_level = 3,
            output = {
                enabled = true,
                open_on_run = "short",
            },
            output_panel = {
                enabled = true,
                open = "botright split | resize 15",
            },
            projects = {},
            quickfix = {
                enabled = true,
                open = true,
            },
            run = {
                enabled = true,
            },
            running = {
                concurrent = true,
            },
            state = {
                enabled = true,
            },
            status = {
                enabled = true,
                signs = true,
                virtual_text = false,
            },
            strategies = {
                integrated = {
                    height = 40,
                    width = 120,
                },
            },
            summary = {
                animated = true,
                enabled = true,
                expand_errors = true,
                follow = true,
                mappings = summ_map,
                open = "botright vsplit | vertical resize 50",
            },
        }

        nt.setup(config)
    end,
}
