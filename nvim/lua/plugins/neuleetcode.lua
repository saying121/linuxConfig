return {
    "mbledkowski/neuleetcode.vim",
    build = "pip3 install keyring browser-cookie3 --user",
    -- lazy = true,
    cmd = "LeetCodeList",
    config = function()
        vim.g.leetcode_browser = "chrome"
        vim.g.leetcode_china = 1
        vim.g.leetcode_hide_paid_only = 1
        vim.g.leetcode_hide_topics = 0
        -- Values: 'c', 'cpp', 'csharp', 'java', 'kotlin', 'scala', 'python', 'python3', 'ruby', 'javascript', 'typescript', 'php', 'swift', 'rust', 'golang', 'erlang', 'racket', 'erlang'.
        vim.g.leetcode_solution_filetype = "rust"
    end,
}
