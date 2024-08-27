local api = vim.api
local vfn = vim.fn

---@type LazySpec
return {
    "rest-nvim/rest.nvim",
    cmd = { "Rest" },
    dependencies = {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
        opts = {
            rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
        },
    },
    ft = "http",
    config = function()
        require("telescope").load_extension("rest")
        -- local keymap = vim.keymap.set
        -- keymap("n", "<leader>rn", "<Plug>RestNvim")
        -- keymap("n", "<leader>rp", "<Plug>RestNvimPreview")
        -- keymap("n", "<leader>rl", "<Plug>RestNvimLast")
        --
        -- api.nvim_create_user_command("RestNvim", function()
        --     require("rest-nvim").run()
        -- end, {})
        -- api.nvim_create_user_command("RestNvimPreview", function()
        --     require("rest-nvim").run(true)
        -- end, {})
        -- api.nvim_create_user_command("RestNvimLast", function()
        --     require("rest-nvim").last()
        -- end, {})

        require("rest-nvim").setup({})
    end,
}
