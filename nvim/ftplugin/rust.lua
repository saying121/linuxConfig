local utils = require("public.utils")

local really_root = utils.get_git_root_dir(vim.fn.getcwd(), "/Cargo.toml")

-- local function is_git_repo()
--     vim.fn.system("git rev-parse --is-inside-work-tree")
--
--     return vim.v.shell_error == 0
-- end
--
-- local function get_git_root()
--     if not is_git_repo() then
--         return nil
--     end
--     local dot_git_path = vim.fn.finddir(".git", ".;")
--     return vim.fn.fnamemodify(dot_git_path, ":h")
-- end
-- really_root =get_git_root()

-- 打开Cargo.toml文件
vim.keymap.set("n", "<c-p>", function()
    if really_root == nil then
        print("Don't exists Cargo.toml")
    else
        vim.api.nvim_command("tabnew " .. really_root .. "/Cargo.toml")
    end
end, { noremap = true, silent = true, buffer = true })

vim.g.termdebugger = "rust-lldb"
