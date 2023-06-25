return {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    -- event = {
    --     "UIEnter *.rs",
    --     "BufNew *.rs",
    -- },
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-lua/plenary.nvim",
        "mfussenegger/nvim-dap",
        "mattn/webapi-vim",
    },
    config = function()
        local extension_path = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/codelldb/extension/"
        ---@diagnostic disable-next-line: unused-local
        local codelldb_path = extension_path .. "adapter/codelldb"
        ---@diagnostic disable-next-line: unused-local
        local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

        local rt = require("rust-tools")

        rt.setup({
            tools = {
                -- how to execute terminal commands
                -- options right now: termopen / quickfix
                executor = require("rust-tools.executors").toggleterm,
                -- callback to execute once rust-analyzer is done initializing the workspace
                -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
                on_initialized = nil,
                -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
                reload_workspace_from_cargo_toml = true,
                -- These apply to the default RustSetInlayHints command
                inlay_hints = {
                    -- automatically set inlay hints (type hints)
                    -- default: true
                    auto = _G.inlay_hints,
                    -- Only show inlay hints for the current line
                    only_current_line = false,
                    -- whether to show parameter hints with the inlay hints or not
                    -- default: true
                    show_parameter_hints = true,
                    -- prefix for parameter hints
                    -- default: "<-"
                    -- parameter_hints_prefix = "<-- "  ,,
                    parameter_hints_prefix = "  ",
                    -- parameter_hints_prefix = " ⟸  ",
                    -- prefix for all the other hints (type, chaining)
                    -- default: "=>"
                    -- other_hints_prefix = "==> " ,
                    other_hints_prefix = "  ",
                    -- other_hints_prefix = " ⟹  ",
                    -- whether to align to the length of the longest line in the file
                    max_len_align = false,
                    -- padding from the left if max_len_align is true
                    max_len_align_padding = 1,
                    -- whether to align to the extreme right or not
                    right_align = false,
                    -- padding from the right if right_align is true
                    right_align_padding = 7,
                    -- The color of the hints
                    -- highlight = "Comment",
                    highlight = "RustInlayHints",
                },
                -- options same as lsp hover / vim.lsp.util.open_floating_preview()
                hover_actions = {
                    -- the border that is used for the hover window
                    -- see vim.api.nvim_open_win()
                    -- Maximal width of the hover window. Nil means no max.
                    max_width = math.floor(vim.api.nvim_win_get_width(0) / 2),
                    -- Maximal height of the hover window. Nil means no max.
                    max_height = math.floor(vim.api.nvim_win_get_height(0) / 2),
                    -- whether the hover action window gets automatically focused
                    -- default: false
                    auto_focus = false,
                },
                -- settings for showing the crate graph based on graphviz and the dot
                -- command
                crate_graph = {
                    -- Backend used for displaying the graph
                    -- see: https://graphviz.org/docs/outputs/
                    -- default: x11
                    backend = "x11",
                    -- where to store the output, nil for no output stored (relative
                    -- path from pwd)
                    -- default: nil
                    output = nil,
                    -- true for all crates.io and external crates, false only the local
                    -- crates
                    -- default: true
                    full = true,
                },
            },
            server = {
                -- standalone file support
                -- setting it to false may improve startup time
                standalone = true,
                on_attach = function(client, bufnr)
                    require("public.lsp_attach").on_attach(client, bufnr)
                    local keymap, opts = vim.keymap.set, { noremap = true, silent = true, buffer = bufnr }

                    keymap("n", "<M-f>", function()
                        rt.hover_actions.hover_actions()
                        rt.hover_actions.hover_actions()
                    end, opts)
                    keymap("n", "mk", ":RustMoveItemUp<CR>", opts)
                    keymap("n", "mj", ":RustMoveItemDown<CR>", opts)
                    keymap("n", "<leader>R", rt.runnables.runnables, opts)
                    keymap("n", "<C-g>", rt.open_cargo_toml.open_cargo_toml, opts)
                    keymap("n", "<S-CR>", rt.expand_macro.expand_macro, opts)

                    -- keymap("n", "<C-g>", function()
                    --     vim.api.nvim_command("tabnew RustOpenCargo")
                    --     rt.open_cargo_toml.open_cargo_toml()
                    -- end, opts)
                end,
                settings = require("plugins.lsps.rust-tools.settings"),
            },
            dap = {
                -- adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
                adapter = require("dap").adapters.codelldb,
                -- adapter = {
                --     type = "executeable",
                --     command = "lldb-vscode",
                --     name = "rt_lldb",
                -- },
            },
        })

        -- VeryLazy 情况要显示启动，懒加载会导致 standalone 有问题
        -- vim.cmd("LspStart")
    end,
}
