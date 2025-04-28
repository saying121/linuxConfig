local my_ft = require("public.ft")

local fts = { "toml" ,'toml_rs'}

local ft = my_ft.filename["Cargo.toml"]
if type(ft) == "string" then
    table.insert(fts, ft)
end
ft = my_ft.filename["rust-toolchain.toml"]
if type(ft) == "string" then
    table.insert(fts, ft)
end

---@type vim.lsp.Config
return {
    cmd = { "taplo", "lsp", "stdio" },
    filetypes = fts,
    settings = {},
}
