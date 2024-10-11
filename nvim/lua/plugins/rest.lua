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
    end,
}
