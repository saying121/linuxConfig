local M = {}

function M.mirror()
    if vim.env.HTTPS_PROXY == nil then
        return "https://ghproxy.com/"
    else
        return ""
    end
end

--- 给一个起始目录，向父级目录寻找 目标目录 或 文件
--- start_dir: 是从哪里开始找
--- be_finded: 被找的目录名字，或者文件名（要带/前缀，例如‘/.git’,'/Cargo.toml'）
---@param start_dir string
---@param be_finded string
---@return string | nil
function M.get_git_root_dir(start_dir, be_finded)
    -- return vim.fn.fnamemodify(vim.fn.finddir(be_finded, "..;"), ":h")

    -- 使用vim.loop.fs_stat检查目录是否存在
    local stat = vim.loop.fs_stat(start_dir)
    -- 如果不存在，返回nil
    if not stat then
        return nil
    end
    -- 如果存在，拼接.git目录的路径
    local git_dir = start_dir .. be_finded
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
    ---@diagnostic disable-next-line: param-type-mismatch
    return M.get_git_root_dir(parent_dir, be_finded)
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
function M.req_lua_files_return_table(mod_path)
    local path = vim.fn.stdpath("config") .. "/lua/" .. mod_path
    local file_list = vim.fn.readdir(path)
    local Table = {}

    for _, file_name in pairs(file_list) do
        if vim.endswith(file_name, ".lua") then
            local use_name = string.sub(file_name, 1, #file_name - 4)
            table.insert(Table, require(mod_path .. "/" .. use_name))
        end
    end

    return Table
end

--- 设置不影响启动时间的启动事件
--- `ft`:table 要满足 val 为文件后缀名.key为文件类型或其他标识符
---@param ft table
---@return table
function M.boot_event(ft)
    local events = {}
    for _, value in pairs(ft) do
        table.insert(events, "UIEnter *." .. value)
        table.insert(events, "BufNew *." .. value)
        table.insert(events, "LspAttach *." .. value)
    end
    return events
end

function M.for_keymap_pattern(ft)
    local pattern = {}
    for _, value in pairs(ft) do
        table.insert(pattern, "*." .. value)
        table.insert(pattern, "*." .. value)
    end
    return pattern
end

--- 判断文件是否存在
---@param file string
---@return boolean
function M.file_exists(file)
    local f = io.open(file, "rb")
    if f then
        f:close()
    end
    return f ~= nil
end

return M
