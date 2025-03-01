---@class DAPBreakpointOptions
---@field condition? string
---@field logMessage? string
---@field hitCondition? string

---@type LazySpec
return {
    "Weissle/persistent-breakpoints.nvim",
    lazy = true,
    config = function(self, opts)
        require("persistent-breakpoints").setup({
            save_dir = vim.fn.stdpath("data") .. "/nvim_checkpoints",
            -- when to load the breakpoints? "BufReadPost" is recommanded.
            load_breakpoints_event = nil,
            -- record the performance of different function. run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
            perf_record = false,
            -- perform callback when loading a persisted breakpoint
            ---@param opts DAPBreakpointOptions options used to create the breakpoint
            ---@param buf_id integer the buffer the breakpoint was set on
            ---@param line integer the line the breakpoint was set on
            on_load_breakpoint = function(opts, buf_id, line)
            end,
        })
    end,
}
