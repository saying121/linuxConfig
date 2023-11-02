return {
    "ray-x/web-tools.nvim",
    build = "npm install -g browser-sync",
    event = {
        "UIEnter *.html",
        "BufNew *.html",
        "BufEnter *.js",
        "BufNew *.js",
        "BufEnter *.ts",
        "BufNew *.ts",
    },
    config = function()
        require("web-tools").setup({
            keymaps = {
                rename = nil, -- by default use same setup of lspconfig
                repeat_rename = "", -- . to repeat
            },
            hurl = { -- hurl default
                show_headers = false, -- do not show http headers
                floating = false, -- use floating windows (need guihua.lua)
                formatters = { -- format the result by filetype
                    json = { "jq" },
                    html = { "prettier", "--parser", "html" },
                },
            },
        })
    end,
}
