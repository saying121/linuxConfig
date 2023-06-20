return {
    "Weissle/persistent-breakpoints.nvim",
    config = function()
        require("persistent-breakpoints").setup({
            save_dir = vim.fn.stdpath("data") .. "/nvim_checkpoints",
            -- load_breakpoints_event = { "BufReadPost" },
            -- record the performance of different function. run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
            perf_record = false,
        })
        local opts = { noremap = true, silent = true }
        local keymap = vim.keymap.set
        local persistent = require("persistent-breakpoints.api")
        -- Save breakpoints to file automatically.
        keymap("n", "<leader>tb", function()
            persistent.toggle_breakpoint()
        end, opts)
        keymap("n", "<leader>sc", function()
            persistent.set_conditional_breakpoint()
        end, opts)
        keymap("n", "<leader>cl", function()
            persistent.clear_all_breakpoints()
        end, opts)
    end,
}
