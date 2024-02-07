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
    },
    config = function()
        local executors = require("rustaceanvim.executors")
        local extension_path = "/usr/lib/codelldb/"

        if not require("public.utils").file_exists(extension_path) then
            extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/"
        end

        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

        local cfg = require("rustaceanvim.config")
        vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {
                --- callback to execute once rust-analyzer is done initializing the workspace
                --- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
                on_initialized = function(health)
                    if health == "ok" then
                        print("----", health)
                        print("check")
                        vim.cmd.RustLsp("flyCheck") -- defaults to 'run'
                    end
                end,
                --- how to execute terminal commands
                --- options right now: termopen / quickfix / toggleterm / vimux
                executor = executors.toggleterm,
                test_executor = executors.toggleterm,

                code_actions = {
                    ui_select_fallback = false,
                },

                ---@type boolean
                -- enable_nextest = vim.fn.executable("cargo-nextest") == 1,
                enable_nextest = false,

                --- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
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
                --- standalone file support
                --- setting it to false may improve startup time
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
                    local keymap, opts = vim.keymap.set, { noremap = true, silent = true, buffer = bufnr }

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
                    end, opts)

                    keymap("n", "<M-f>", function()
                        vim.cmd.RustLsp({ "hover", "actions" })
                    end, opts)
                    keymap("x", "<M-f>", function()
                        vim.cmd.RustLsp({ "hover", "range" })
                    end, opts)
                    keymap("n", "mk", function()
                        vim.cmd.RustLsp({ "moveItem", "up" })
                    end, opts)
                    keymap("n", "mj", function()
                        vim.cmd.RustLsp({ "moveItem", "down" })
                    end, opts)
                    keymap("n", "<leader>R", function()
                        vim.cmd.RustLsp("runnables")
                    end, opts)
                    keymap("n", "<leader>D", function()
                        vim.cmd.RustLsp({
                            "debuggables" --[[ , 'last' ]],
                        })
                    end, opts)
                    keymap("n", "<C-g>", function()
                        vim.cmd.RustLsp("openCargo")
                    end, opts)
                    keymap("n", "<S-CR>", function()
                        vim.cmd.RustLsp("expandMacro")
                    end, opts)
                    keymap("n", "<M-S-CR>", function()
                        vim.cmd.RustLsp("rebuildProcMacros")
                    end, opts)

                    keymap("n", "J", function()
                        vim.cmd.RustLsp("joinLines")
                    end, opts)
                end,
                default_settings = require("public.ra.settings"),
                ---@type table | (fun(project_root:string|nil):table)
                settings = function(project_root)
                    local ra = require("rustaceanvim.config.server")
                    return ra.load_rust_analyzer_settings(project_root, {
                        settings_file_pattern = "rust-analyzer.json",
                    })
                end,
            },
            -- DAP configuration
            dap = {
                adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
            },
        }

        vim.cmd.e()
    end,
}
