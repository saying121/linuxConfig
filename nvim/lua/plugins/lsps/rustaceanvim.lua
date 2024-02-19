---@class RustAnalyzerInitializedStatus
---@field health lsp_server_health_status
---@field quiescent boolean inactive?

---@alias lsp_server_health_status 'ok' | 'warning' | 'error'

return {
    "mrcjkb/rustaceanvim",
    -- cond = false,
    version = "^4",
    event = {
        "UIEnter *rs",
        -- "BufWrite *rs",
        "BufNew *rs",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "mfussenegger/nvim-dap",
        {
            "vxpm/ferris.nvim",
            opts = {
                -- If true, will automatically create commands for each LSP method
                create_commands = true, -- bool
                -- Handler for URL's (used for opening documentation)
                url_handler = "xdg-open", -- string | function(string)
            },
            -- ft = "rust",
            config = function(_, opt)
                require("ferris").setup(opt)
            end,
        },
    },
    config = function()
        local executors = require("rustaceanvim.executors")
        local extension_path = "/usr/lib/codelldb/"

        if not require("public.utils").file_exists(extension_path) then
            extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/"
        end

        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

        vim.g.rustaceanvim = {
            tools = {
                --- callback to execute once rust-analyzer is done initializing the workspace
                ---@param health RustAnalyzerInitializedStatus
                on_initialized = function(health)
                    if health.health == "ok" then
                        vim.lsp.codelens.refresh()
                        vim.cmd.RustLsp("flyCheck")
                    elseif health.health == "warning" then
                        vim.notify("ra health" .. health.health, vim.log.levels.WARN)
                    elseif health.health == "error" then
                        vim.notify("ra health" .. health.health, vim.log.levels.ERROR)
                    end
                end,

                --- options right now: termopen / quickfix / toggleterm / vimux
                executor = executors.toggleterm,
                test_executor = executors.toggleterm,

                code_actions = { ui_select_fallback = false },

                ---@type boolean
                -- enable_nextest = vim.fn.executable("cargo-nextest") == 1,

                ---@type boolean
                reload_workspace_from_cargo_toml = true,
                hover_actions = { replace_builtin_hover = false },

                float_win_config = {
                    -- the border that is used for the hover window or explain_error window
                    ---@see vim.api.nvim_open_win()
                    ---@type string[][] | string
                    border = "rounded",
                    max_width = math.floor(vim.api.nvim_win_get_width(0) * 0.7),
                    max_height = math.floor(vim.api.nvim_win_get_height(0) * 0.7),

                    --- whether the floating window gets automatically focused
                    --- default: false
                    ---@type boolean
                    auto_focus = true,
                },
                rustc = { edition = "2021" },
            },
            -- LSP configuration
            server = {
                ---@type boolean
                standalone = true,
                ---@param client lsp.Client
                ---@param bufnr integer
                on_attach = function(client, bufnr)
                    local group_name = "RustFlyCheck"
                    vim.api.nvim_create_augroup(group_name, { clear = false })
                    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group_name })
                    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                        group = group_name,
                        buffer = bufnr,
                        callback = function()
                            vim.cmd.RustLsp("flyCheck") -- defaults to 'run'
                            -- vim.cmd.RustLsp({ "flyCheck", "run" })
                            -- vim.cmd.RustLsp({ "flyCheck", "clear" })
                            -- vim.cmd.RustLsp({ "flyCheck", "cancel" })
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
                        local diagnostics = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
                        local found = false
                        for _, diagnostic in ipairs(diagnostics) do
                            if diagnostic.source == "rustc" then
                                found = true
                                break
                            end
                        end
                        if found then
                            vim.cmd.RustLsp("explainError")
                        else
                            vim.cmd.RustLsp("renderDiagnostic")
                        end
                    end)

                    keymap("n", "<M-f>", function()
                        vim.cmd.RustLsp({ "hover", "actions" })
                    end)
                    keymap("x", "<M-f>", function()
                        vim.cmd.RustLsp({ "hover", "range" })
                    end)
                    keymap("n", "mk", function()
                        vim.cmd.RustLsp({ "moveItem", "up" })
                    end)
                    keymap("n", "mj", function()
                        vim.cmd.RustLsp({ "moveItem", "down" })
                    end)
                    keymap("n", "<leader>R", function()
                        vim.cmd.RustLsp("runnables")
                    end)
                    keymap("n", "<leader>D", function()
                        vim.cmd.RustLsp({
                            "debuggables" --[[ , 'last' ]],
                        })
                    end)
                    keymap("n", "<C-g>", function()
                        vim.cmd.RustLsp("openCargo")
                    end)
                    keymap("n", "<S-CR>", function()
                        vim.cmd.RustLsp("expandMacro")
                    end)
                    keymap("n", "<M-S-CR>", function()
                        vim.cmd.RustLsp("codeAction")
                    end)

                    keymap("n", "J", function()
                        vim.cmd.RustLsp("joinLines")
                    end)
                end,
                default_settings = require("public.ra"),
                ---@type table | (fun(project_root:string|nil):table)
                settings = function(project_root)
                    local ra = require("rustaceanvim.config.server")
                    return ra.load_rust_analyzer_settings(project_root, {
                        settings_file_pattern = "rust-analyzer.json",
                    })
                end,
            },
            -- DAP configuration
            dap = { adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path) },
        }

        vim.cmd.e()
    end,
}
