local api, lsp, vcmd = vim.api, vim.lsp, vim.cmd

---@type LazySpec
return {
    "mrcjkb/rustaceanvim",
    version = "*",
    event = {
        "UIEnter *.rs",
        "BufNew *.rs",
        "BufEnter *.rs",
    },
    dependencies = {
        "mfussenegger/nvim-dap",
        {
            "vxpm/ferris.nvim",
            opts = {
                -- If true, will automatically create commands for each LSP method
                create_commands = true, -- bool
                -- Handler for URL's (used for opening documentation)
                url_handler = "xdg-open", -- string | function(string)
            },
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

        ---@type RustaceanConfig
        vim.g.rustaceanvim = {
            tools = {
                --- callback to execute once rust-analyzer is done initializing the workspace
                ---@type fun(health: RustAnalyzerInitializedStatus) | nil
                on_initialized = function(status)
                    local health = status.health

                    if health == "ok" then
                        vcmd.RustLsp("flyCheck")
                        lsp.codelens.refresh()
                    elseif health == "warning" then
                        vim.notify("ra health" .. health, vim.log.levels.WARN)
                    elseif health == "error" then
                        vim.notify("ra health" .. health, vim.log.levels.ERROR)
                    end
                end,

                --- options right now: termopen / quickfix / toggleterm / vimux
                executor = executors.toggleterm,
                test_executor = executors.toggleterm,

                code_actions = { ui_select_fallback = false },

                ---@type boolean
                enable_nextest = false,

                ---@type boolean
                reload_workspace_from_cargo_toml = true,
                hover_actions = { replace_builtin_hover = false },

                float_win_config = {
                    -- the border that is used for the hover window or explain_error window
                    ---@see vim.api.nvim_open_win()
                    ---@type string[][] | string
                    border = "rounded",
                    max_width = math.floor(api.nvim_win_get_width(0) * 0.7),
                    max_height = math.floor(api.nvim_win_get_height(0) * 0.7),

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
                            vcmd.RustLsp("flyCheck") -- defaults to 'run'
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
                            vcmd.RustLsp("explainError")
                        else
                            vcmd.RustLsp("renderDiagnostic")
                        end
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
                        vcmd.RustLsp("runnables")
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
                    project_root = project_root or vim.fn.getcwd()
                    default_settings = require("public.ra")

                    local ra = require("rustaceanvim.config.server")

                    -- if string.find(project_root, "decrypt-browser") then
                    --     default_settings.cargo.target = { "" }
                    -- end

                    ---@type RustAnzlyzerConfig
                    local st = ra.load_rust_analyzer_settings(project_root .. "/.vscode", {
                        -- settings_file_pattern = "rust-analyzer.json",
                        settings_file_pattern = "settings.json",
                        default_settings = default_settings,
                    })
                    local res = vim.tbl_deep_extend("keep", default_settings, st)
                    -- vim.print(res)
                    return res
                end,
            },
            -- DAP configuration
            dap = { adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path) },
        }

        vcmd.e()
    end,
}
