return {
    "mbledkowski/neuleetcode.vim",
    build = "pip3 install keyring browser-cookie3 --user",
    -- lazy = true,
    cmd = "LeetcodeList",
    config = function()
        -- vim.cmd[[ let g:leetcode_browser='chrome']]
        -- vim.cmd[[ let g:leetcode_china=1]]
        vim.g.leetcode_browser = "chrome"
        vim.g.leetcode_china = 1
        -- Values: 'c', 'cpp', 'csharp', 'java', 'kotlin', 'scala', 'python', 'python3', 'ruby', 'javascript', 'typescript', 'php', 'swift', 'rust', 'golang', 'erlang', 'racket', 'erlang'.
        vim.g.leetcode_solution_filetype = "python3"
    end,
}
