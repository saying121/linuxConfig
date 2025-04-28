local vfn = vim.fn

---@type LazySpec
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre" },
    config = function()
        local lspconfig = require("lspconfig")

        require("lspconfig.ui.windows").default_options.border = "single"

        lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
            autostart = true,
        })

        local lsp = vim.lsp

        -- 要禁用某个 lsp 就去改后缀名
        local lsp_path = vfn.stdpath("config") .. "/after/lsp"
        local file_name_list = vfn.readdir(lsp_path)

        local lsps = {}
        for _, the_file_name in ipairs(file_name_list) do
            if not vim.endswith(the_file_name, ".lua") then
                goto continue
            end
            local lsp_name = string.sub(the_file_name, 1, #the_file_name - 4)

            table.insert(lsps, lsp_name)

            ::continue::
        end

        lsp.enable(lsps)
    end,
}
