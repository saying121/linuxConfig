return {
    "navarasu/onedark.nvim",
    event = "BufWinEnter",
    cond = false,
    config = function()
        require("onedark").setup({
            style = "cool",
            transparent = true, -- Show/hide background
            term_colors = true, -- Change terminal color as per the selected theme style
            ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
            cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

            -- toggle theme style ---
            toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
            toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

            -- Lualine options --
            lualine = {
                transparent = true, -- lualine center bar transparency
            },
        })
        vim.cmd.colorscheme("onedark")
        vim.cmd.colorscheme("mycolors")
    end,
}
