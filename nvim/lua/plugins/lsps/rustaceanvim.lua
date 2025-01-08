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
        "akinsho/toggleterm.nvim",
        {
            "vxpm/ferris.nvim",
            opts = {
                create_commands = false,
            },
        },
    },
    config = function()
        local extension_path = require("public.utils").find_vscode_codelldb()

        local executors = require("rustaceanvim.executors")

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

                executor = executors.toggleterm,
                test_executor = executors.toggleterm,

                code_actions = {
                    ui_select_fallback = true,
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

                    require("public.lsp_attach").on_attach(client, bufnr)

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
                    keymap("n", "<M-S-CR>", function()
                        vcmd.RustLsp("codeAction")
                    end)

                    keymap({ "n", "x" }, "J", function()
                        vcmd.RustLsp("joinLines")
                    end)
                end,
                default_settings = require("public.ra"),
                ---@type table | (fun(project_root:string|nil, default_settings: RustAnzlyzerConfig|nil):table) -- The rust-analyzer settings or a function that creates them.
                settings = function(project_root, default_settings)
                    project_root = project_root or vim.uv.cwd()
                    default_settings = require("public.ra")

                    local ra = require("rustaceanvim.config.server")

                    -- if string.find(project_root, "decrypt-browser") then
                    --     default_settings.cargo.target = { "" }
                    -- end

                    local st =
                        ra.load_rust_analyzer_settings(project_root, { settings_file_pattern = "rust-analyzer.json" })

                    -- ---@type RustAnzlyzerConfig
                    -- local st = ra.load_rust_analyzer_settings(project_root .. "/.vscode", {
                    --     -- settings_file_pattern = "rust-analyzer.json",
                    --     settings_file_pattern = "settings.json",
                    --     default_settings = default_settings,
                    -- })
                    local res = vim.tbl_deep_extend("keep", default_settings, st)
                    -- vim.print(res)
                    return res
                end,
            },
            dap = {
                adapter = function()
                    local this_os = vim.uv.os_uname().sysname
                    if this_os:find("Windows") or this_os:find("Darwin") then
                        local dap_config = require("rustaceanvim.config").get_codelldb_adapter(
                            extension_path.codelldb_path,
                            extension_path.liblldb_path
                        )
                        return dap_config
                    else
                        -- Archlinux install from aur
                        return {
                            type = "server",
                            host = "127.0.0.1",
                            port = "port",
                            executable = {
                                command = "codelldb",
                                args = { "--port", "port" },
                            },
                        }
                    end
                end,
            },
        }

        vim.g.rustaceanvim = cfg
    end,
}
