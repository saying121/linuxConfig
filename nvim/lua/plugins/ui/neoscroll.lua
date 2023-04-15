return {
    "karb94/neoscroll.nvim",
    -- event = "VeryLazy",
    keys = {
        "<C-u>",
        "<C-d>",
        "<C-b>",
        "<C-f>",
        "<C-y>",
        "<C-e>",
        "zt",
        "zz",
        "zb",
        -- "gg",
        -- "G",
    },
    config = function()
        require("neoscroll").setup({
            -- All these keys will be mapped to their corresponding default scrolling animation
            -- mappings = {
            --     "<C-u>",
            --     "<C-d>",
            --     "<C-b>",
            --     "<C-f>",
            --     "<C-y>",
            --     "<C-e>",
            --     "zt",
            --     "zz",
            --     "zb",
            --     "gg",
            --     "G",
            -- },
            hide_cursor = true, -- Hide cursor while scrolling
            stop_eof = false, -- Stop at <EOF> when scrolling downwards
            respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
            cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
            easing_function = nil, -- Default easing function
            pre_hook = nil, -- Function to run before the scrolling animation starts
            post_hook = nil, -- Function to run after the scrolling animation ends
            performance_mode = false, -- Disable "Performance Mode" on all buffers.
        })

        local t = {}
        -- Syntax: t[keys] = {function, {function arguments}}
        -- `quadratic`, `cubic`, `quartic`, `quintic`, `circular`, `sine`.
        t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "250", "cubic" } }
        t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "250", "cubic" } }
        t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "450", "sine" } }
        t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "450", "sine" } }
        t["<C-y>"] = { "scroll", { "-0.10", "false", "100" } }
        t["<C-e>"] = { "scroll", { "0.10", "false", "100" } }
        t["zt"] = { "zt", { "250" } }
        t["zz"] = { "zz", { "250" } }
        t["zb"] = { "zb", { "250" } }
        -- t["gg"] = { "gg", { "50" } }
        -- t["G"] = { "G", { "50" } }

        require("neoscroll.config").set_mappings(t)
    end,
}
