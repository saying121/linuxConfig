return {
    "rcarriga/cmp-dap",
    cond = true,
    ft = "dap-repl",
    config = function()
        require("cmp").setup({
            enabled = function()
                return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
            end,
        })

        require("cmp").setup.filetype({ "dap-repl" }, {
            sources = {
                { name = "dap" },
            },
        })
    end,
}
