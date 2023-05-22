local ft = {
    "dap-repl",
    "dapui_watches",
    "dapui_hover",
}

local events = {}

for _, value in pairs(ft) do
    table.insert(events, "UIEnter *." .. value)
    table.insert(events, "BufNew *." .. value)
end

return {
    "rcarriga/cmp-dap",
    event = events,
    config = function()
        require("cmp").setup({
            enabled = function()
                return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
            end,
        })

        require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
            sources = {
                { name = "dap" },
            },
        })
    end,
}
