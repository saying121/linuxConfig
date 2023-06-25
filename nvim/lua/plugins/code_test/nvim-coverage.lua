return {
    "andythigpen/nvim-coverage",
    build = "cargo install grcov",
    cmd = {
        "Coverage",
        "CoverageSummary",
    },
    config = function()
        local util = require("public.utils")
        local git_root = util.get_git_root_dir(vim.fn.getcwd(), "/.git")

        local coverage = require("coverage")

        coverage.setup({
            lang = {
                rust = {
                    -- 先回到项目/仓库根目录然后才行
                    coverage_command = "cd "
                        .. git_root
                        .. " && grcov "
                        .. git_root
                        .. " -s "
                        .. git_root
                        .. " --binary-path ./target/debug/ -t coveralls --branch --ignore-not-existing --token NO_TOKEN",
                    project_files_only = true,
                    project_files = { "src/*", "tests/*" },
                },
            },
            auto_reload = true,
            load_coverage_cb = function(ftype)
                require("notify")(
                    "Loaded " .. ftype .. " coverage",
                    vim.log.levels.INFO,
                    { render = "minimal", timeout = 1000, hide_from_history = true }
                )
            end,
            signs = {
                -- use your own highlight groups or text markers
                covered = { hl = "CoverageCovered", text = "▎" },
                uncovered = { hl = "CoverageUncovered", text = "▎" },
                partial = { hl = "CoveragePartial", text = "▎" },
            },
        })
    end,
}
