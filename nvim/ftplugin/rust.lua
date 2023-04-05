-- local git_root = io.popen("git rev-parse --show-toplevel") -- 执行命令
-- local the_root = git_root:read("*a") -- 读取所有输出
--
-- if the_root == nil then
--     print('It\'s not a rust project.')
--     return
-- else
--     the_root = the_root
-- end
--
-- local really_root = string.gsub(the_root, '%s+$', '')
--
--
-- git_root:close() -- 关闭文件描述符

-- 定义一个函数，接受一个目录作为参数
local function get_git_root(dir, be_find)
    -- 使用vim.loop.fs_stat检查目录是否存在
    local stat = vim.loop.fs_stat(dir)
    -- 如果不存在，返回nil
    if not stat then
        return nil
    end
    -- 如果存在，拼接.git目录的路径
    local git_dir = dir .. be_find
    -- 使用vim.loop.fs_stat检查.git目录是否存在
    local git_stat = vim.loop.fs_stat(git_dir)
    -- 如果存在，返回当前目录
    if git_stat then
        return dir
    end
    -- 如果不存在，获取上一级目录的路径
    local parent_dir = vim.fn.fnamemodify(dir, ":h")
    -- 如果上一级目录和当前目录相同，说明已经到达根目录，返回nil
    if parent_dir == dir then
        return nil
    end
    -- 否则，递归调用函数，传入上一级目录作为参数
    return get_git_root(parent_dir, be_find)
end

-- 调用函数，传入当前工作目录和要找的文件夹作为参数
local really_root = get_git_root(vim.fn.getcwd(), "/.git")
-- 打开Cargo.toml文件
vim.keymap.set('n', '<c-p>', function()
    vim.api.nvim_command('tabnew ' .. really_root .. '/Cargo.toml')
    -- print(really_root)
end, { noremap = true, silent = true })
