local utils = require("public.utils")

local M = {}

local handle = io.popen("rustc --version")
local output
if handle then
    output = handle:read("*a")
    handle:close()
end
local is_nightly = string.find(output, "nightly") ~= nil

-- cache
local rust_version = {}

--- 把rustc --version --verbose 解析为kv
---@return table|nil
function M.parse_rustc_version()
    if not vim.tbl_isempty(rust_version) then
        return rust_version
    end

    local version_string = utils.cmd_stdout("rustc --version --verbose")
    if version_string == nil then
        return nil
    end
    for line in version_string:gmatch("[^\r\n]+") do
        local key, value = line:match("^(.-):%s*(.*)$")
        if key then
            rust_version[key] = value
        end
    end

    return rust_version
end

-- 获取 lsp 名字
function M.lsp_clients()
    local msg = "No Lsp"
    local lsps = ""

    local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if next(clients) == nil then
        return msg
    end

    for _, client in ipairs(clients) do
        local name
        if buf_ft == "rust" and is_nightly then
            local rust_info = M.parse_rustc_version()
            if rust_info then
                name = "ra-" .. rust_info.release
            else
                name = "ra-nightly"
            end
        else
            name = client.name
        end
        if lsps ~= "" then
            lsps = lsps .. ", " .. name
        else
            lsps = name
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
        return "OS:󰀵"
    end

    return uname.sysname
end

return M
