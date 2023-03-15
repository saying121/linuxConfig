local git_root = io.popen("git rev-parse --show-toplevel") -- 执行命令
local the_root = git_root:read("*a") -- 读取所有输出

if the_root == nil then
    print('It\'s not a rust project.')
    return
else
    the_root = the_root
end

local really_root = string.gsub(the_root, '%s+$', '')


git_root:close() -- 关闭文件描述符

-- 打开Cargo.toml文件
vim.keymap.set('n', '<c-p>', function()
    vim.api.nvim_command('tabnew ' .. really_root .. '/Cargo.toml')
    -- print(really_root)
end, { noremap = true, silent = true })
