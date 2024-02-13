local M = {}

local handle = io.popen("rust-analyzer --version")
local output
if handle then
    output = handle:read("*a")
    handle:close()
end
local is_nightly = string.find(output, "nightly") ~= nil

-- 获取 lsp 名字
function M.lsp_clients()
    local msg = "No Active Lsp"
    local lsps = ""
    local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
        return msg
    end

    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            local name
            if buf_ft == "rust" and is_nightly then
                name = "ra-nightly"
            else
                name = client.name
            end
            if lsps ~= "" then
                lsps = lsps .. ", " .. name
            else
                lsps = name
            end
        end
    end

    if lsps == "" then
        return msg
    end
    return lsps
end

-- 获取发行版名字
function M.get_distro_name()
    local file = io.open("/etc/os-release", "r")
    if file then
        for line in file:lines() do
            if line:match("^ID=") then
                return line:gsub("ID=", ""):gsub('"', "")
            end
        end
        file:close()
    end
    return nil
end

-- 获取发行版系统信息和图标
function M.linux_distro()
    if vim.env.TERMUX_VERSION ~= nil then
        return "OS:"
    end

    local distro = {
        arch = "",
        kali = "",
        ubuntu = "",
        suse = "",
        manjaro = "",
        pop = "",
    }

    local uname = vim.uv.os_uname()
    if uname.sysname == "Linux" then
        local your_distro = M.get_distro_name()

        if distro[your_distro] ~= nil then
            return "OS:" .. distro[your_distro]
        else
            return "OS:" .. "Linux"
        end
    end

    if vim.fn.has("win") then
        return "OS:"
    elseif vim.fn.has("mac") then
        return "OS:"
    end

    return uname.sysname
end

--- 获取文件格式
---@return string
function M.fileformat()
    local fft = vim.bo.fileformat

    local distro = {
        arch = "",
        kali = "",
        ubuntu = "",
        suse = "",
        manjaro = "",
        pop = "",
    }

    if fft == "unix" then
        local your_distro = M.get_distro_name()

        if distro[your_distro] ~= nil then
            return "FF:" .. distro[your_distro]
        else
            return "FF:" .. "Linux"
        end
    end

    if fft == "dos" then
        return "FF:"
    elseif fft == "mac" then
        return "FF:"
    end

    return fft
end

return M
