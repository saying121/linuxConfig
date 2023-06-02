local M = {}
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
    if not M.file_exists(file) then
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

--- 在表的长度里面随机取值
---@param the_list table
---@return integer
function M.get_rand(the_list)
    -- return math.random(1, #the_list)
    return vim.fn.rand() % #the_list + 1
end

--- 获取文件路径
---@param dir_name string
---@return string
function M.get_random_file_path(dir_name)
    local dir_path = vim.fn.stdpath("config") .. "/dashboard/" .. dir_name
    local file_name = vim.fn.readdir(dir_path)
    -- local file_name = { 'dragon.cat' } -- 测试某个
    return dir_path .. "/" .. file_name[M.get_rand(file_name)]
end

return M
