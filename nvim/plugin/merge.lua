-- local M = {}

-- 合并 dependencies目录下的表，他们必须返回一张表，这个函数会把他们放到一个大表中
-- dir_name == telescopes 时
-- ~/.config/nvim/lua/plugins/telescopes/dependencies/project.lua
-- ~/.config/nvim/lua/plugins/telescopes/dependencies/telescope-dap.lua
-- {
-- project.lua 返回的表,
-- telescope-dap.lua 返回的表,
-- ......
-- }
get_dependencies_table = function(dir_name)
    local path = vim.fn.stdpath("config") .. "/lua/plugins/" .. dir_name .. "/dependencies"
    local dependencies_list = vim.fn.readdir(path)
    local DepTable = {}

    for _, file_name in pairs(dependencies_list) do
        if string.sub(file_name, #file_name - 3) == ".lua" then
            local use_name = string.sub(file_name, 1, #file_name - 4)
            table.insert(DepTable, require("plugins." .. dir_name .. ".dependencies." .. use_name))
        end
    end

    return DepTable
end

-- return M
