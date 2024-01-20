return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        "<M-t>",
        "<A-d>",
        "<leader>g",
        "<leader>or",
    },
    cmd = { "ToggleTerm" },
    config = function()
        local keymap, opts = vim.keymap.set, { silent = true, noremap = true }
        keymap({ "n" }, "<M-t>", ":ToggleTerm<CR>", opts)
        keymap({ "t" }, "<M-t>", "<C-\\><C-n>:ToggleTerm<CR>", opts)

        require("toggleterm").setup({
            size = function(term)
                if term.direction == "horizontal" then
                    return 20
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            direction = "float",
            highlights = {
                -- highlights which map to a highlight group name and a table of it's values
                -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
                FloatBorder = {
                    guifg = "#2ac3de",
                    -- guibg = "<VALUE-HERE>",
                },
            },
            -- open_mapping = [[<c-\>]],
        })
        -- local term_width = vim.o.columns
        -- local term_height = vim.o.lines
        local Terminal = require("toggleterm.terminal").Terminal
        local gitui = Terminal:new({
            cmd = "gitui",
            hidden = true,
            direction = "float",
            float_opts = {
                border = "double",
                -- like `size`, width and height can be a number or function which is passed the current terminal
                -- width = function()
                --     return vim.o.columns * 0.8
                -- end,
                -- height = function()
                --     return vim.o.lines * 0.8
                -- end,
                width = 150,
                height = 40,
                winblend = 3,
            },
        })
        local function gitui_toggle()
            gitui:toggle()
        end
        keymap("n", "<leader>gu", gitui_toggle, opts)

        local lldb = Terminal:new({
            cmd = [[echo 'lldb 相关设置';echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope]],
            direction = "float",
            float_opts = {
                border = "double",
                -- like `size`, width and height can be a number or function which is passed the current terminal
                width = 70,
                height = 5,
                -- winblend = 3,
            },
        })
        local function set_lldb()
            lldb:toggle()
        end
        keymap({ "n", "t" }, "<A-d>", set_lldb, opts)
    end,
}
