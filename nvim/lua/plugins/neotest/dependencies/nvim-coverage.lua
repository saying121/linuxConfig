return {
    "andythigpen/nvim-coverage",
    build = "cargo install grcov",
    config = function()
        require("coverage").setup({
            signs = {
                -- use your own highlight groups or text markers
                covered = { hl = "CoverageCovered", text = "▎" },
                uncovered = { hl = "CoverageUncovered", text = "▎" },
                partial = { hl = "CoveragePartial", text = "▎" },
            },
        })
    end,
}
