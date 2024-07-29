local utils = require("public.utils")

local really_root = utils.get_root_dir(vim.uv.cwd(), "/Cargo.toml")

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
        vim.notify("Don't exists Cargo.toml", vim.log.levels.INFO, {})
    else
        vim.api.nvim_command("tabnew " .. really_root .. "/Cargo.toml")
    end
end, { noremap = true, silent = true, buffer = true })

vim.g.termdebugger = "rust-lldb"

local function ra_settings(dir)
    local settings = require("public.ra")
    local settings_json = vim.json.encode(settings)

    local root

    if string.len(dir) > 0 then
        root = dir
    else
        local dir = utils.get_root_dir(vim.uv.cwd(), "/.git")
        if dir then
            root = dir
        else
            root = vim.uv.cwd()
        end
    end
    local path = root .. "/rust-analyzer.json"
    vim.notify(path, vim.log.levels.INFO)

    local file = io.open(path, "w")

    if file then
        file:write(settings_json)

        file:close()
        vim.notify("generated", vim.log.levels.INFO)
    else
        vim.notify("failed", vim.log.levels.INFO)
    end
end

vim.api.nvim_create_user_command("RustJsonSettings", function(opts)
    ra_settings(opts.args)
end, {
    nargs = "?",
    complete = "dir",
})
