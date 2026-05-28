---@type LazySpec
return {
    "folke/trouble.nvim",
    keys = {
        { "<space>ll", mode = { "n" } },
        { "<space>lm", mode = { "n" } },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local opts = { silent = true, noremap = true }
        local keymap = vim.keymap.set

        keymap("n", "<space>ll", function()
            vim.cmd.Trouble({ "diagnostics", "toggle", "filter.buf=0" })
        end, opts)
        keymap("n", "<space>lm", function()
            vim.cmd.Trouble({ "diagnostics", "toggle" })
        end, opts)

        local defaults = {
            auto_close = true, -- auto close when there are no items
            auto_open = false, -- auto open when there are items
            auto_preview = true, -- automatically open preview when on an item
            auto_refresh = true, -- auto refresh when open
            auto_jump = false, -- auto jump to the item when there's only one
            focus = true, -- Focus the window when opened
            restore = true, -- restores the last location in the list when opening
            follow = true, -- Follow the current item
            indent_guides = true, -- show indent guides
            max_items = 200, -- limit number of items that can be displayed per section
            multiline = true, -- render multi-line messages
            pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
            -- Throttle/Debounce settings. Should usually not be changed.
            ---@type table<string, number|{ms:number, debounce?:boolean}>
            throttle = {
                refresh = 20, -- fetches new data when needed
                update = 10, -- updates the window
                render = 10, -- renders the window
                follow = 100, -- follows the current item
                preview = { ms = 100, debounce = true }, -- shows the preview for the current item
            },
            -- Key mappings can be set to the name of a builtin action,
            -- or you can define your own custom action.
            ---@type table<string, string|trouble.Action>
            keys = {
                ["?"] = "help",
                r = "refresh",
                R = "toggle_refresh",
                q = "close",
                o = "jump_close",
                ["<esc>"] = "cancel",
                ["<cr>"] = "jump",
                ["<2-leftmouse>"] = "jump",
                ["<c-s>"] = "jump_split",
                ["<c-v>"] = "jump_vsplit",
                -- go down to next item (accepts count)
                -- j = "next",
                ["}"] = "next",
                ["]]"] = "next",
                -- go up to prev item (accepts count)
                -- k = "prev",
                ["{"] = "prev",
                ["[["] = "prev",
                i = "inspect",
                p = "preview",
                P = "toggle_preview",
                zo = "fold_open",
                zO = "fold_open_recursive",
                zc = "fold_close",
                zC = "fold_close_recursive",
                za = "fold_toggle",
                zA = "fold_toggle_recursive",
                zm = "fold_more",
                zM = "fold_close_all",
                zr = "fold_reduce",
                zR = "fold_open_all",
                zx = "fold_update",
                zX = "fold_update_all",
                zn = "fold_disable",
                zN = "fold_enable",
                zi = "fold_toggle_enable",
                gb = { -- example of a custom action that toggles the active view filter
                    action = function(view)
                        view.state.filter_buffer = not view.state.filter_buffer
                        view:filter(view.state.filter_buffer and { buf = 0 } or nil)
                    end,
                    desc = "Toggle Current Buffer Filter",
                },
            },
        }
        require("trouble").setup(defaults)
    end,
}
