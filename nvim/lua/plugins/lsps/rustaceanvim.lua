local api, lsp, vcmd = vim.api, vim.lsp, vim.cmd
local log = vim.log

---@type LazySpec
return {
    "mrcjkb/rustaceanvim",
    version = "*",
    ft = "rust",
    -- cond=false,
    dependencies = {
        "mfussenegger/nvim-dap",
        {
            "vxpm/ferris.nvim",
            opts = {
                create_commands = false,
            },
        },
    },
    config = function()
        local snacks = {
            execute_command = function(command, args, cwd, opts)
                local ok, term = pcall(require, "snacks.terminal")
                if not ok then
                    vim.schedule(function()
                        vim.notify("snacks not found.", vim.log.levels.ERROR)
                    end)
                    return
                end

                local shell = require("rustaceanvim.shell")
                term.open(shell.make_command_from_args(command, args), {
                    dir = cwd,
                    env = opts.env,
                    cmd = shell.make_command_from_args(command, args),
                    close_on_exit = false,
                    auto_close = false,
                    auto_insert = false,
                    interactive = false,
                    win = {
                        border = "double",
                    },
                })
            end,
        }

        ---@type rustaceanvim.Opts
        local cfg = {
            tools = {
                on_initialized = function(status)
                    local health = status.health

                    if health == "ok" then
                        vcmd.RustLsp("flyCheck")
                        lsp.codelens.refresh()
                    elseif health == "warning" then
                        vim.notify("ra health is " .. health, log.levels.WARN)
                    elseif health == "error" then
                        vim.notify("ra health is " .. health, log.levels.ERROR)
                    end
                end,

                executor = snacks,
                test_executor = snacks,

                code_actions = {
                    ui_select_fallback = false,
                    keys = {
                        ---@type string | string[]
                        confirm = { "<CR>" },
                        ---@type string | string[]
                        quit = { "q", "<Esc>" },
                    },
                },

                enable_nextest = false,

                reload_workspace_from_cargo_toml = true,
                hover_actions = { replace_builtin_hover = false },

                float_win_config = {
                    border = "rounded",
                    max_width = math.floor(api.nvim_win_get_width(0) * 0.7),
                    max_height = math.floor(api.nvim_win_get_height(0) * 0.7),

                    auto_focus = true,
                },
            },
            -- LSP configuration
            server = {
                ---@type boolean
                standalone = false,
                ---@param client vim.lsp.Client
                ---@param bufnr integer
                on_attach = function(client, bufnr)
                    local group_name = "RustFlyCheck"
                    api.nvim_create_augroup(group_name, { clear = false })
                    api.nvim_clear_autocmds({ buffer = bufnr, group = group_name })
                    api.nvim_create_autocmd({ "BufWritePost" }, {
                        group = group_name,
                        buffer = bufnr,
                        callback = function()
                            vcmd.RustLsp("flyCheck")
                        end,
                    })

                    ---@param mode string|table
                    ---@param lhs string
                    ---@param rhs string|function
                    local function keymap(mode, lhs, rhs)
                        vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
                    end

                    keymap("n", "<leader>ml", require("ferris.methods.view_memory_layout"))
                    keymap("n", "<leader>vi", require("ferris.methods.view_item_tree"))

                    keymap("n", "<M-e>", function()
                        vcmd.RustLsp({ "renderDiagnostic", "cycle" })
                    end)

                    keymap("n", "<M-f>", function()
                        vcmd.RustLsp({ "hover", "actions" })
                    end)
                    keymap("x", "K", function()
                        vcmd.RustLsp({ "hover", "range" })
                    end)
                    keymap("n", "mk", function()
                        vcmd.RustLsp({ "moveItem", "up" })
                    end)
                    keymap("n", "mj", function()
                        vcmd.RustLsp({ "moveItem", "down" })
                    end)
                    keymap("n", "<leader>R", function()
                        vcmd.RustLsp("run")
                    end)
                    keymap("n", "<leader>D", function()
                        vcmd.RustLsp({
                            "debuggables" --[[ , 'last' ]],
                        })
                    end)
                    keymap("n", "<C-g>", function()
                        vcmd.RustLsp("openCargo")
                    end)
                    keymap("n", "<C-S-m>", function()
                        vcmd.RustLsp("rebuildProcMacros")
                    end)
                    keymap("n", "<S-CR>", function()
                        vcmd.RustLsp("expandMacro")
                    end)
                    keymap(
                        {
                            "n", --[[ "x" ]]
                        },
                        "<M-CR>",
                        function()
                            vcmd.RustLsp("codeAction")
                        end
                    )

                    keymap({ "n", "x" }, "J", function()
                        vcmd.RustLsp("joinLines")
                    end)
                end,
                default_settings = require("public.ra"),
            },
            dap = {
                adapter = require("public.utils").codelldb_config(),
            },
        }

        vim.g.rustaceanvim = cfg
    end,
}
