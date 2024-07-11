local M = {}

function M.mirror()
    if vim.env.HTTPS_PROXY == nil then
        return ""
        -- return "https://mirror.ghproxy.com/"
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
function M.get_root_dir(start_dir, be_finded)
    local varName = vim.fs.find(be_finded, {
        upward = true,
        stop = vim.uv.os_homedir(),
        path = start_dir,
        limit = 1,
    })
    return vim.fs.dirname(varName[1])
end

function M.find_root_cwd(be_finded)
    return vim.fn.fnamemodify(vim.fn.finddir(be_finded, ".;"), ":h")
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

--- 从一个文件中读取所有的行，并返回一个包含所有行的表
---@param file string
---@return table
function M.lines_from(file)
    if not require("public.utils").file_exists(file) then
        return {}
    end

    local lines = {}

    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

--- 获取文件行数
---@param file string
---@return integer
function M.get_lines(file)
    local lines = M.lines_from(file)
    local num_lines = #lines -- 表的长度就是行数
    return num_lines
end

--- 获取文件最大列数
---@param file string
---@return integer
function M.get_columns(file)
    local lines = M.lines_from(file)

    local max_columns = 0 -- 初始化最大列数为0
    for _, line in ipairs(lines) do -- 遍历每一行
        local num_columns = #line -- 字符串的长度就是列数
        if num_columns > max_columns then -- 如果当前行的列数大于最大列数，就更新最大列数
            max_columns = num_columns
        end
    end
    -- print(max_columns)

    return max_columns -- 最大列数
end

function M.is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")

    return vim.v.shell_error == 0
end

return M
