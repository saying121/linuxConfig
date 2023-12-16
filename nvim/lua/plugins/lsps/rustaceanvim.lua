return {
    "mrcjkb/rustaceanvim",
    -- cond = false,
    version = "^3", -- Recommended
    ft = "rust",
    config = function()
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
                        vim.cmd.RustLsp("flyCheck") -- defaults to 'run'
                    end
                end,
                --- how to execute terminal commands
                --- options right now: termopen / quickfix / toggleterm / vimux
                executor = require("rustaceanvim.executors").toggleterm,
                --- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
                ---@type boolean
                reload_workspace_from_cargo_toml = true,
                hover_actions = {
                    replace_builtin_hover = false,
                    -- the border that is used for the hover window
                    -- see vim.api.nvim_open_win()
                    -- Maximal width of the hover window. Nil means no max.
                    max_width = math.floor(vim.api.nvim_win_get_width(0) * 0.7),
                    -- Maximal height of the hover window. Nil means no max.
                    max_height = math.floor(vim.api.nvim_win_get_height(0) * 0.7),
                    -- whether the hover action window gets automatically focused
                    -- default: false
                    auto_focus = true,
                },
            },
            -- LSP configuration
            server = {
                --- standalone file support
                --- setting it to false may improve startup time
                ---@type boolean
                standalone = true,
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                        group = vim.api.nvim_create_augroup("RustFlyCheck", { clear = false }),
                        buffer = bufnr,
                        -- pattern = { "*.rs" },
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
                        vim.cmd.RustLsp("explainError")
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
                        vim.cmd.RustLsp({
                            "runnables" --[[ , 'last' ]] --[[ optional ]],
                        })
                    end, opts)
                    keymap("n", "<leader>D", function()
                        vim.cmd.RustLsp({
                            "debuggables" --[[ , 'last' ]] --[[ optional ]],
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
                end,
                settings = require("plugins.lsps.rust.settings"),
                -- settings = function(project_root)
                --     local ra = require("rustaceanvim.config.server")
                --     return ra.load_rust_analyzer_settings(project_root, {
                --         settings_file_pattern = "rust-analyzer.json",
                --     })
                -- end,

                default_settings = require("plugins.lsps.rust.settings"),
            },
            -- DAP configuration
            dap = {
                adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
            },
        }
    end,
}
