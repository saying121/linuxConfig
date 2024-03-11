local M = {}

---@type table<string, string|table|function>
M.extension = {
    foo = "fooscript",
    mir = "rust",
    conf = "conf",
    typ = "typst",
    log = "log",
    yuck = "yuck",
    slint = "slint",
    bar = function(path, bufnr)
        -- if some_condition() then
        --     return "barscript",
        --         function(bufnr)
        --             -- Set a buffer variable
        --             vim.b[bufnr].barscript_version = 2
        --         end
        -- end
        return "bar"
    end,
}
---@type table<string, string|table|function>
M.filename = {
    ["Cargo.toml"] = "toml_rs",
    ["LICENSE"] = "license",
    ["license"] = "license",
    ["config"] = "config",
    ["~/.linuxConfig/wayland/waybar/config"] = "json",
    ["~/.config/waybar/config"] = "json",
    ["~/.config/microsoft-edge/Default/Bookmarks"] = "json",
    ["~/.config/google-chrome/Default/Bookmarks"] = "json",
    ["hyprland.conf"] = "hyprlang",
}
---@type table<string, string|table|function>
M.pattern = {
    ["(?i)LICENSE"] = "license",
    [".*/etc/foo/.*"] = "fooscript",
    ["hyprland.conf"] = "hyprlang",
    [".*/hypr/.*.conf"] = "hyprlang",
    [".*/hypr/lib/.*.conf"] = "hyprlang",
    ["/proc/bus/input/.*"] = "txt",
    -- Using an optional priority
    [".*/etc/foo/.*%.conf"] = { "dosini", { priority = 10 } },
    -- A pattern containing an environment variable
    ["${XDG_CONFIG_HOME}/foo/git"] = "git",
    ["README.(a+)$"] = function(path, bufnr, ext)
        if ext == "md" then
            return "markdown"
        elseif ext == "rst" then
            return "rst"
        end
    end,
}

--- 自定义文件类型
function M.make_ft()
    vim.filetype.add({
        ---@type table<string, string|table|function>
        extension = M.extension,
        ---@type table<string, string|table|function>
        filename = M.filename,
        ---@type table<string, string|table|function>
        pattern = M.pattern,
    })
end

return M
