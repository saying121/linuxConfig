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
    {
        view = "mini",
        filter = { event = "notify.warn", kind = "", find = "Client 2 quit with exit code 101 and signal 0" },
        opts = {
            skip = true,
        },
    },
    {
        view = "mini",
        filter = { event = "warn", kind = "", find = "Client" },
        opts = {
            skip = true,
        },
    },
}
