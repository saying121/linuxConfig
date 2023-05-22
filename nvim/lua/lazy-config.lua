local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    -- stylua: ignore
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local specs = {
    { import = "plugins" },
}

local path = vim.fn.stdpath("config") .. "/lua/plugins"

-- 导入plugins文件夹下面的文件夹，里面的文件
for _, file_name in pairs(vim.fn.readdir(path)) do
    -- if string.sub(file_name, #file_name - 3) ~= ".lua" then
    if not vim.endswith(file_name, ".lua") then
        table.insert(specs, { import = "plugins." .. file_name })
    end
end

require("lazy").setup({
    spec = specs,
    root = vim.fn.stdpath("data") .. "/lazy", -- directory where plugins will be installed
    defaults = {
        lazy = false, -- should plugins be lazy-loaded?
        version = nil, -- version = "*", -- enable this to try installing the latest stable versions of plugins
    },
    -- leave nil when passing the spec as the first argument to setup()
    -- spec = nil, ---@type LazySpec
    lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json", -- lockfile generated after running update.
    concurrency = nil, ---@type number limit the maximum amount of concurrent tasks
    git = {
        -- defaults for the `Lazy log` command
        -- log = { "-10" }, -- show the last 10 commits
        log = { "--since=3 days ago" }, -- show commits from the last 3 days
        timeout = 120, -- kill processes that take more than 2 minutes
        url_format = "https://github.com/%s.git",
    },
    dev = {
        -- directory where you store your local plugin projects
        path = "~/projects",
        ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
        patterns = {}, -- For example {"folke"}
    },
    install = {
        missing = true, -- install missing plugins on startup. This doesn't increase startup time.
        colorscheme = { "tokyonight", "habamax" }, -- try to load one of these colorschemes when starting an installation during startup
    },
    ui = {
        size = { width = 0.8, height = 0.8 }, -- a number <1 is a percentage., >1 is a fixed size
        -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        border = "double", -- "rounded", "shadow", "single",
        icons = {
            ft = "",
            lazy = "鈴 ",
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
        cmd = "git",
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
            path = vim.fn.stdpath("cache") .. "/lazy/cache",
            -- Once one of the following events triggers, caching will be disabled.
            -- To cache all modules, set this to `{}`, but that is not recommended.
            disable_events = { "UIEnter", "BufReadPre", "VimEnter" },
            -- disable_events = {},
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
                "tutor",
            },
        },
    },
    -- lazy can generate helptags from the headings in markdown readme files,
    -- so :help works even for plugins that don't have vim docs.
    -- when the readme opens with :help it will be correctly displayed as markdown
    readme = {
        root = vim.fn.stdpath("state") .. "/lazy/readme",
        files = { "README.md", "lua/**/README.md" },
        -- only generate markdown helptags for plugins that dont have docs
        skip_if_doc_exists = false,
    },
})
