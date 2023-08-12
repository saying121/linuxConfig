return {
    "smoka7/multicursors.nvim",
    -- event = "VeryLazy",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "smoka7/hydra.nvim",
    },
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
        {
            mode = { "v", "n" },
            "<Leader>m",
            "<cmd>MCstart<cr>",
            desc = "Create a selection for selcted text or word under the cursor",
        },
    },
     opts = function()
        local N = require("multicursors.normal_mode")
        local I = require("multicursors.insert_mode")
        return {
            DEBUG_MODE = false,
            create_commands = true, -- create Multicursor user commands
            updatetime = 50, -- selections get updated if this many milliseconds nothing is typed in the insert mode see :help updatetime
            nowait = true, -- see :help :map-nowait
            normal_keys = {
                -- to change default lhs of key mapping change the key
                [","] = {
                    -- assigning nil to method exits from multi cursor mode
                    method = N.clear_others,
                    -- you can pass :map-arguments here
                    opts = { desc = "Clear others" },
                },
            },
            insert_keys = {
                -- to change default lhs of key mapping change the key
                ["<CR>"] = {
                    -- assigning nil to method exits from multi cursor mode
                    method = I.Cr_method,
                    -- you can pass :map-arguments here
                    opts = { desc = "New line" },
                },
            },
            -- extend_keys = extend_keys
            -- see :help hydra-config.hint
            hint_config = {
                border = "none",
                position = "bottom",
            },
            -- accepted values:
            -- -1 true: generate hints
            -- -2 false: don't generate hints
            -- -3 [[multi line string]] provide your own hints
            generate_hints = {
                normal = false,
                insert = false,
                extend = false,
            },
        }
    end,
}
