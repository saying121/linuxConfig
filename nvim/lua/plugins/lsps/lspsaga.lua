return {
    "glepnir/lspsaga.nvim",
    -- Do make sure that your LSP plugins, like lsp-zero or lsp-config, are loaded before loading lspsaga.
    event = "LspAttach",
    -- cond = function()
    --     if #vim.lsp.get_active_clients() <= 1 then
    --         return false
    --     end
    --     return true
    -- end,
    commit = "76696bed4397c3b58563c246dc1f7856ed4af023",
    -- commit = "388ab180bf4360ede33e7b1c77fcd8c7f94e33b2",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        -- Please make sure you install markdown and markdown_inline parser
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("lspsaga").setup({
            symbol_in_winbar = {
                enable = true,
                separator = " ",
                hide_keyword = true,
                show_file = true,
                folder_level = 2,
                respect_root = false,
                color_mode = true,
            },
            finder = {
                --percentage
                max_height = 0.5,
                min_width = 30,
                force_max_height = false,
                keys = {
                    jump_to = "p",
                    edit = { "o", "<CR>" },
                    vsplit = "v",
                    split = "s",
                    tabe = "t",
                    tabnew = "r",
                    quit = { "q", "<ESC>" },
                    close_in_preview = "<ESC>",
                },
            },
            definition = {
                edit = "<C-c>o",
                vsplit = "<C-c>v",
                split = "<C-c>i",
                tabe = "<C-c>t",
                quit = "q",
            },
            code_action = {
                num_shortcut = true,
                show_server_name = true,
                extend_gitsigns = false,
                keys = {
                    -- string | table type
                    quit = { "q", "<ESC>" },
                    exec = "<CR>",
                },
            },
            lightbulb = {
                enable = true,
                enable_in_insert = true,
                sign = true,
                sign_priority = 40,
                virtual_text = false,
            },
            diagnostic = {
                on_insert = true,
                on_insert_follow = false,
                insert_winblend = 0,
                show_virt_line = true,
                show_code_action = true,
                show_source = true,
                jump_num_shortcut = true,
                -- 1 is max
                max_width = 0.7,
                custom_fix = nil,
                custom_msg = nil,
                text_hl_follow = false,
                border_follow = true,
                keys = {
                    exec_action = "o",
                    quit = "q",
                    go_action = "g",
                    expand_or_jump = "<CR>",
                    quit_in_show = { "q", "<ESC>" },
                },
            },
            rename = {
                quit = "<C-c>",
                exec = "<CR>",
                mark = "x",
                confirm = "<CR>",
                in_select = false,
            },
            outline = {
                win_position = "right",
                win_with = "",
                win_width = 30,
                show_detail = true,
                auto_preview = true,
                auto_refresh = true,
                auto_close = true,
                custom_sort = nil,
                keys = {
                    jump = "o",
                    expand_collapse = "u",
                    quit = "q",
                },
            },
            callhierarchy = {
                show_detail = false,
                keys = {
                    edit = "e",
                    vsplit = "v",
                    split = "s",
                    tabe = "t",
                    jump = "o",
                    quit = "q",
                    expand_collapse = "u",
                },
            },
            beacon = {
                enable = true,
                frequency = 7,
            },
            ui = {
                -- This option only works in Neovim 0.9
                title = true,
                -- Border type can be single, double, rounded, solid, shadow.
                border = "single",
                winblend = 0,
                expand = "",
                collapse = "",
                code_action = "💡",
                incoming = " ",
                outgoing = " ",
                hover = " ",
                kind = {},
            },
        })
        -- vim.wo.winbar /
        -- vim.wo.stl = require("lspsaga.symbolwinbar"):get_winbar()
        local keymap = vim.keymap.set
        -- LSP finder - Find the symbol's definition
        -- If there is no definition, it will instead be hidden
        -- When you use an action in finder like "open vsplit",
        -- you can use <C-t> to jump back
        keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
        keymap({ "n", "x" }, "<M-CR>", "<cmd>Lspsaga code_action<CR>")
        -- Rename all occurrences of the hovered word for the entire file
        keymap("n", "<space>rn", "<cmd>Lspsaga rename<CR>")
        -- Rename all occurrences of the hovered word for the selected files
        keymap("n", "<space>Rn", "<cmd>Lspsaga rename ++project<CR>")
        -- You can edit the file containing the definition in the floating window
        -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
        -- It also supports tagstack
        -- Use <C-t> to jump back
        keymap("n", "gD", ":Lspsaga peek_definition<CR>")
        -- Go to definition
        keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>")
        -- Peek type definition
        -- You can edit the file containing the type definition in the floating window
        -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
        -- It also supports tagstack
        -- Use <C-t> to jump back
        keymap("n", "gY", "<cmd>Lspsaga peek_type_definition<CR>")

        -- Go to type definition
        keymap("n", "gy", "<cmd>Lspsaga goto_type_definition<CR>")
        -- Show line diagnostics
        -- You can pass argument ++unfocus to
        -- unfocus the show_line_diagnostics floating window
        if vim.bo.filetype == "markdown" then
            local theopts = { noremap = true, silent = true }
            keymap("n", "<space>gg", vim.diagnostic.open_float, theopts)
        else
            keymap("n", "<space>gg", "<cmd>Lspsaga show_line_diagnostics<CR>")
        end

        -- keymap("n", "<space>sw", "<cmd>Lspsaga show_workspace_diagnostics<CR>")
        -- Show buffer diagnostics
        -- keymap("n", "<space>ll", "<cmd>Lspsaga show_buf_diagnostics<CR>")
        -- Diagnostic jump
        keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
        keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")
        -- Diagnostic jump with filters such as only jumping to an error
        keymap("n", "[e", function()
            require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end)
        keymap("n", "]e", function()
            require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end)

        keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>")
        -- To disable it just use ":Lspsaga hover_doc ++quiet"
        -- Pressing the key twice will enter the hover window
        -- keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")

        local function peekOrHover()
            local winid = require("ufo").peekFoldedLinesUnderCursor()
            -- keymap 好像没效果，虽然 keymap 成功，只能自己先 `trace`(按下按键展开折叠) 然后再编辑了
            if winid then
                local bufnr = vim.api.nvim_win_get_buf(winid)
                local keys = { "a", "i", "o", "A", "I", "O", "gd", "gr" }
                for _, k in ipairs(keys) do
                    -- Add a prefix key to fire `trace` action,
                    vim.keymap.set("n", k, "<CR>" .. k, { noremap = false, buffer = bufnr })
                end
            end
            return winid
        end

        -- 和 crates.nvim,nvim-ufo,nvim-dap-ui 集成
        local function show_documentation()
            if vim.tbl_contains({ "vim", "help" }, vim.bo.filetype) then
                vim.cmd("h " .. vim.fn.expand("<cword>"))
            elseif vim.tbl_contains({ "man" }, vim.bo.filetype) then
                vim.cmd("Man " .. vim.fn.expand("<cword>"))
            elseif vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                require("crates").show_popup()
            elseif _G.dapui_for_K == 1 then
                require("dapui").eval()
            elseif not peekOrHover() then
                vim.cmd([[Lspsaga hover_doc]])
            end
        end
        keymap("n", "K", show_documentation, { silent = true })

        -- If you want to jump to the hover window you should use the wincmd command "<C-w>w"
        keymap("n", "ck", "<cmd>Lspsaga hover_doc ++keep<CR>")
        -- Call hierarchy
        keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
        keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

        keymap({ "n", "t" }, "<A-a>", "<cmd>Lspsaga term_toggle<CR>")
    end,
}
