return {
    {
        view = "mini",
        filter = { event = "msg_show", kind = "", find = "change" },
        opts = {
            skip = true,
        },
    },
    {
        view = "mini",
        filter = { event = "msg_show", kind = "", find = "after" },
        opts = {
            skip = true,
        },
    },
    {
        view = "mini",
        filter = { event = "msg_show", kind = "", find = "before" },
        opts = {
            skip = true,
        },
    },
    -- {
    --     view = "mini",
    --     filter = { event = "msg_show", kind = "", find = "info" },
    --     opts = {
    --         skip = false,
    --     },
    -- },
    {
        view = "mini",
        filter = { event = "msg_show", kind = "", find = "line" },
        opts = {
            skip = true,
        },
    },
    {
        view = "mini",
        filter = { event = "msg_show", kind = "", find = "written" },
        opts = {
            skip = false,
        },
    },
    -- {
    --     view = "mini",
    --     filter = { event = "msg_show", kind = "", find = "yanked" },
    --     opts = {
    --         skip = true,
    --     },
    -- },
    -- {
    --     view = "mini",
    --     filter = { event = "msg_show", kind = "echo", find = "Running healthchecks" },
    --     opts = {
    --         skip = false,
    --     },
    -- },
    -- {
    --     -- view = "mini",
    --     filter = { event = "msg_show", kind = "echo", find = "nil" },
    --     opts = {
    --         skip = true,
    --     },
    -- },
    -- {
    --     -- view = "mini",
    --     filter = { event = "msg_show", kind = "echo", find = "Starting Java Language Server" },
    --     opts = {
    --         skip = true,
    --     },
    -- },
    -- {
    --     -- view = "mini",
    --     filter = { event = "msg_show", kind = "echo", find = "Init" },
    --     opts = {
    --         skip = true,
    --     },
    -- },
    -- {
    --     view = "mini",
    --     filter = { event = "msg_show", kind = "echo", find = "Ready" },
    --     opts = {
    --         skip = true,
    --     },
    -- },
    -- {
    --     view = "mini",
    --     filter = { event = "msg_show", kind = "echo", find = "Ok" },
    --     opts = {
    --         skip = true,
    --     },
    -- },
    -- {
    --     view = "mini",
    --     filter = { event = "msg_show", kind = "echo", find = "Paused" },
    --     opts = {
    --         skip = true,
    --     },
    -- },
    -- {
    --     view = "mini",
    --     filter = { event = "msg_show", kind = "echo", find = "no targets" },
    --     opts = {
    --         skip = false,
    --     },
    -- },
    -- {
    --     view = "mini",
    --     filter = { event = "msg_show", kind = { "echo" }, find = "" },
    --     opts = {
    --         skip = false,
    --     },
    -- },
    -- {
    --     view = "popup",
    --     filter = { event = "msg_show", kind = {}, find = "all" },
    --     opts = {
    --         skip = false,
    --     },
    -- },
}
