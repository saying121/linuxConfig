local vfn = vim.fn
local lazypath = vfn.stdpath("data") .. "/lazy/lazy.nvim"
local mirror = require("public.utils").mirror()

local dev_path = vim.fn.expand("~/nvim-plugin/")

if not vim.uv.fs_stat(lazypath) then
    vfn.system({
        "git",
        "clone",
        "--filter=blob:none",
        mirror .. "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
vim.opt.rtp:prepend(dev_path)
-- vim.opt.rtp:prepend("/usr/lib/helix/runtime/grammars")

local specs = {
    { import = "plugins" },
    { import = "plugins.blink" },
    { import = "plugins.database" },
    { import = "plugins.edit" },
    { import = "plugins.lsps" },
    { import = "plugins.navigation" },
    { import = "plugins.nvim-dap" },
    { import = "plugins.previews" },
    { import = "plugins.translators" },
    { import = "plugins.treesitter" },
    { import = "plugins.ui" },
    { import = "plugins.utils" },
}

---@type LazyConfig
require("lazy").setup({
    -- leave nil when passing the spec as the first argument to setup()
    spec = specs, ---@type table<LazySpec>
    root = vfn.stdpath("data") .. "/lazy", -- directory where plugins will be installed
    defaults = {
        lazy = false, -- should plugins be lazy-loaded?
        version = nil, -- version = "*", -- enable this to try installing the latest stable versions of plugins
    },
    lockfile = vfn.stdpath("data") .. "/lazy/lazy-lock.json", -- lockfile generated after running update.
    git = {
        -- defaults for the `Lazy log` command
        -- log = { "-10" }, -- show the last 10 commits
        log = { "--since=3 days ago" }, -- show commits from the last 3 days
        timeout = 60, -- seconds
        url_format = mirror .. "https://github.com/%s.git",
    },
    dev = {
        -- directory where you store your local plugin projects
        ---@type string | fun(plugin: LazyPlugin): string
        path = dev_path,
        ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
        patterns = {
            "saying121",
            -- "dyninput",
            -- "rustaceanvim",
        }, -- For example {"folke"}
        fallback = true,
    },
    install = {
        missing = true, -- install missing plugins on startup. This doesn't increase startup time.
        -- colorscheme = { "tokyonight", "habamax", "mycolors" }, -- try to load one of these colorschemes when starting an installation during startup
    },
    ui = {
        size = { width = 0.8, height = 0.8 }, -- a number <1 is a percentage., >1 is a fixed size
        -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        border = "double", -- "rounded", "shadow", "single",
        icons = {
            ft = "",
            lazy = "󰒲 ",
            loaded = "",
            not_loaded = "",
        },
        -- leave nil, to automatically select a browser depending on your OS.
        -- If you want to use a specific browser, you can define it here
        browser = nil, ---@type string?
        throttle = 20, -- how frequently should the ui process render events
    },
    diff = {
        -- diff command <d> can be one of:
        -- * browser: opens the github compare view. Note that this is always mapped to <K> as well,
        --   so you can have a different command for diff <d>
        -- * git: will run git diff and open a buffer with filetype git
        -- * terminal_git: will open a pseudo terminal with git diff
        -- * diffview.nvim: will open Diffview to show the diff
        cmd = "diffview.nvim",
    },
    checker = {
        enabled = false, -- automatically check for plugin updates
        concurrency = nil, ---@type number? set to 1 to check for updates very slowly
        notify = false, -- get a notification when new updates are found
        -- frequency = 3600, -- check for updates every hour
        frequency = 3600 * 24 * 7, -- check for updates every week
    },
    change_detection = {
        enabled = false, -- automatically check for config file changes and reload the ui
        notify = false, -- get a notification when changes are found
    },
    performance = {
        cache = {
            enabled = true,
            path = vfn.stdpath("cache") .. "/lazy/cache",
            -- Once one of the following events triggers, caching will be disabled.
            -- To cache all modules, set this to `{}`, but that is not recommended.
            disable_events = { "UIEnter", "BufReadPre", "BufWinEnter" },
            ttl = 3600 * 24 * 5, -- keep unused modules for up to 5 days
        },
        reset_packpath = true, -- reset the package path to improve startup time
        rtp = {
            reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
            ---@type string[]
            paths = {}, -- add any custom paths here that you want to indluce in the rtp
            ---@type string[] list any plugins you want to disable here
            disabled_plugins = {
                -- "matchit",
                -- "tohtml",
                -- "tutor",
            },
        },
    },
    rocks = {
        enabled = true,
        hererocks = true,
    },
})
