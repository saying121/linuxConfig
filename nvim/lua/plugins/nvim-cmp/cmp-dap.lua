local api = vim.api
---@type LazySpec
return {
    "rcarriga/cmp-dap",
    cond = false,
    lazy = true,
    ft = "dap-repl",
    config = function()
        require("cmp").setup({
            enabled = function()
                return api.nvim_get_option_value("filetype", { scope = "local" }) ~= "prompt"
                    or require("cmp_dap").is_dap_buffer()
            end,
        })

        require("cmp").setup.filetype({ "dap-repl" }, {
            sources = {
                { name = "dap" },
            },
        })
    end,
}
