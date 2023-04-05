return {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm" },
    config = function()
        require("toggleterm").setup({
            size = function(term)
                if term.direction == "horizontal" then
                    return 20
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            direction = "float",
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

        local lldb = Terminal:new({
            cmd = [[echo 'lldb 相关设置';echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope]],
            direction = "float",
            float_opts = {
                border = "double",
                -- like `size`, width and height can be a number or function which is passed the current terminal
                width = 70,
                height = 5,
                winblend = 3,
            },
        })
        local function set_lldb()
            lldb:toggle()
        end

        local opts, keymap = { noremap = true, silent = true }, vim.keymap.set
        keymap("n", "<leader>g", gitui_toggle, opts)
        keymap({ "n", "t" }, "<A-d>", set_lldb, opts)
    end,
}
