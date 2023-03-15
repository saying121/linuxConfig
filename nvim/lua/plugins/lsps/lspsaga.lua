return {
    "glepnir/lspsaga.nvim",
    -- event = 'BufRead',
    commit = "438b54cba00fca27d280ae4d9242615282045bcb",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
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
                keys = {
                    jump_to = "p",
                    edit = { "o", "<CR>" },
                    vsplit = "s",
                    split = "i",
                    tabe = "t",
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
                close = "<Esc>",
            },
            code_action = {
                num_shortcut = true,
                show_server_name = true,
                keys = {
                    -- string | table type
                    quit = "q",
                    exec = "<CR>",
                },
            },
            lightbulb = {
                enable = true,
                enable_in_insert = true,
                sign = false,
                sign_priority = 40,
                virtual_text = true,
            },
            diagnostic = {
                show_code_action = true,
                show_source = true,
                jump_num_shortcut = true,
                --1 is max
                max_width = 0.7,
                custom_fix = nil,
                custom_msg = nil,
                text_hl_follow = false,
                border_follow = true,
                keys = {
                    exec_action = "o",
                    quit = "q",
                    go_action = "g",
                },
            },
            rename = {
                quit = "<C-c>",
                exec = "<CR>",
                mark = "x",
                confirm = "<CR>",
                in_select = true,
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
                    vsplit = "s",
                    split = "i",
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
        })
        -- vim.wo.winbar /
        vim.wo.stl = require("lspsaga.symbolwinbar"):get_winbar()
        local keymap = vim.keymap.set
        -- LSP finder - Find the symbol's definition
        -- If there is no definition, it will instead be hidden
        -- When you use an action in finder like "open vsplit",
        -- you can use <C-t> to jump back
        keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
        -- Code action
        keymap({ "n", "v" }, "<M-CR>", "<cmd>Lspsaga code_action<CR>")
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
        -- Show line diagnostics
        -- You can pass argument ++unfocus to
        -- unfocus the show_line_diagnostics floating window
        if vim.bo.filetype == "markdown" then
            local theopts = { noremap = true, silent = true }
            keymap("n", "<space>gg", vim.diagnostic.open_float, theopts)
            keymap("n", "[d", vim.diagnostic.goto_prev, theopts)
        else
            keymap("n", "<space>gg", "<cmd>Lspsaga show_line_diagnostics<CR>")
        end

        -- Show cursor diagnostics
        -- Like show_line_diagnostics, it supports passing the ++unfocus argument
        keymap("n", "<space>sd", "<cmd>Lspsaga show_cursor_diagnostics<CR>")
        -- Show buffer diagnostics
        -- keymap("n", "<space>ll", "<cmd>Lspsaga show_buf_diagnostics<CR>")
        -- Diagnostic jump
        keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
        keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_n")
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
        keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")
        -- If you want to jump to the hover window you should use the wincmd command "<C-w>w"
        keymap("n", "zk", "<cmd>Lspsaga hover_doc ++keep<CR>")
        -- Call hierarchy
        keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
        keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

        keymap({ "n", "t" }, "<A-a>", "<cmd>Lspsaga term_toggle<CR>")
    end,
}
