return {
    "andymass/vim-matchup",
    keys = "%",
    -- event = "VeryLazy",
    config = function()
        -- may set any options here
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
}
