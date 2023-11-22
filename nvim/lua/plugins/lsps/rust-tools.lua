return {
    "simrat39/rust-tools.nvim",
    -- cond = false,
    ft = "rust",
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-lua/plenary.nvim",
        "mfussenegger/nvim-dap",
        "mattn/webapi-vim",
    },
    config = function()
        local extension_path = "/usr/lib/codelldb/"

        if not require("public.utils").file_exists(extension_path) then
            extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/"
        end
        if not require("public.utils").file_exists(extension_path) then
            extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/"
        end

        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

        local rt = require("rust-tools")

        local function ra()
            local status = os.execute("systemctl is-active --quiet ra-mulitplex.service")
            if status == 0 then
                return { "ra-multiplex" }
            else
                return { "rust-analyzer" }
            end
        end
        local cmd = ra()

        rt.setup({
            tools = {
                -- how to execute terminal commands
                -- options right now: termopen / quickfix / toggleterm / vimux
                executor = require("rust-tools.executors").toggleterm,
                -- callback to execute once rust-analyzer is done initializing the workspace
                -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
                on_initialized = function(health)
                    if health == "error" then
                        -- vim.cmd.RustReloadWorkspace()
                        vim.cmd.LspStart()
                    end
                end,
                -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
                reload_workspace_from_cargo_toml = true,
                -- These apply to the default RustSetInlayHints command
                inlay_hints = { auto = vim.fn.has("nvim-0.10.0") ~= 1 },
                -- options same as lsp hover / vim.lsp.util.open_floating_preview()
                hover_actions = {
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
            server = {
                -- standalone file support
                -- setting it to false may improve startup time
                standalone = true,
                -- cmd = { "ra-multiplex" },
                on_attach = function(client, bufnr)
                    require("public.lsp_attach").on_attach(client, bufnr)
                    local keymap, opts = vim.keymap.set, { noremap = true, silent = true, buffer = bufnr }

                    keymap("n", "<M-f>", rt.hover_actions.hover_actions, opts)
                    keymap("n", "mk", vim.cmd.RustMoveItemUp, opts)
                    keymap("n", "mj", vim.cmd.RustMoveItemDown, opts)
                    keymap("n", "<leader>R", rt.runnables.runnables, opts)
                    keymap("n", "<leader>D", vim.cmd.RustDebuggables, opts)

                    keymap("n", "<C-g>", rt.open_cargo_toml.open_cargo_toml, opts)
                    keymap("n", "<S-CR>", rt.expand_macro.expand_macro, opts)
                end,
                settings = require("plugins.lsps.rust.settings"),
            },
            dap = {
                adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
                -- adapter = require("dap").adapters.gdb,
            },
        })
    end,
}
