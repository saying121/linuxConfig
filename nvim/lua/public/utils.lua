local M = {}

--- 给一个起始目录，向父级目录寻找 目标目录 或 文件
--- start_dir: 是从哪里开始找
--- be_finded: 被找的目录名字，或者文件名（要带/前缀，例如‘/.git’,'/Cargo.toml'）
---@param start_dir string
---@param be_finded_dir string
---@return string | nil
function M.get_git_root_dir(start_dir, be_finded_dir)
    -- return vim.fn.fnamemodify(vim.fn.finddir(be_finded, "..;"), ":h")

    -- 使用vim.loop.fs_stat检查目录是否存在
    local stat = vim.loop.fs_stat(start_dir)
    -- 如果不存在，返回nil
    if not stat then
        return nil
    end
    -- 如果存在，拼接.git目录的路径
    local git_dir = start_dir .. be_finded_dir
    -- 使用vim.loop.fs_stat检查.git目录是否存在
    local git_stat = vim.loop.fs_stat(git_dir)
    -- 如果存在，返回当前目录
    if git_stat then
        return start_dir
    end
    -- 如果不存在，获取上一级目录的路径
    local parent_dir = vim.fn.fnamemodify(start_dir, ":h")
    -- 如果上一级目录和当前目录相同，说明已经到达根目录，返回nil
    if parent_dir == start_dir then
        return nil
    end
    -- 否则，递归调用函数，传入上一级目录作为参数
    return M.get_git_root_dir(parent_dir, be_finded_dir)
end

--- 合并mod_path目录下的表，他们必须返回一张表，这个函数会把他们放到一个大表中
--- `mod_path == plugins/telescope/dependencies` 时
--- 目录结构
--- ```lua
--- ~/.config/nvim/lua/plugins/telescope/dependencies/project.lua
--- ~/.config/nvim/lua/plugins/telescope/dependencies/telescope-dap.lua
--- ```
--- 返回结果
--- ```lua
--- ......
--- {
--- project.lua -- 返回的表,
--- telescope-dap.lua -- 返回的表,
--- ......
--- }
--- ```
---@param mod_path string
---@return table
function M.get_dependencies_table(mod_path)
    local path = vim.fn.stdpath("config") .. "/lua/" .. mod_path
    local dependencies_list = vim.fn.readdir(path)
    local DepTable = {}

    for _, file_name in pairs(dependencies_list) do
        -- if string.sub(file_name, #file_name - 3) == ".lua" then
        if vim.endswith(file_name, ".lua") then
            local use_name = string.sub(file_name, 1, #file_name - 4)
            table.insert(DepTable, require( mod_path .. "/" .. use_name))
        end
    end

    return DepTable
end

return M
