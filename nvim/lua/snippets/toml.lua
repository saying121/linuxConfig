---@diagnostic disable: unused-local
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet

local crates = {
    ["open"] = "使用系统上配置的程序打开路径或 url",
    ["opener"] = "使用系统默认程序打开文件或链接。",
    ["itertools"] = "额外的迭代器适配器、迭代器方法、自由函数和宏。",
    ["atty"] = "一个简单的查询 atty 的接口,你是还是不是 tty？",
    ["beef"] = "更紧凑的牛",
    ["defer-drop"] = "推迟将大型类型删除到后台线程",
    ["derive_builder"] = "派生 **Rust** 结构的构建器实现",
    ["rayon"] = "**Rust** 一个数据并行库，它可以让你轻松地把顺序计算转换成并行计算，并且保证没有数据竞争1。它根据运行时的工作负载自动调整并行度2。",
    ["semver"] = "用于Cargo语义版本控制风格的解析器和评估器",
    ["get-cookie"] = "从本地浏览器的 cookie 存储中获取 cookie",
    ["captcha"] = "用于生成验证码的库。",
    ["cookie"] = "http cookie 解析和 cookie jar 管理。支持签名和私有（加密、验证）jar。",
    ["inline-python"] = "直接在 **Rust** 代码中内联 **Python** 代码",
    ["mimalloc"] = "面向性能和安全的嵌入式分配器",
    ["GraphQL"] = "rust lang 的 graphql 参考实现。",
    ["keyring"] = "用于管理密码/凭据的跨平台库",
    ["atoi"] = "直接从安全代码中的 `[u8]` 切片解析整数",
    ["bitflags"] = "一个类型安全的位掩码标志生成器，对 **C** 风格标志集很有用。它可用于围绕 **C** api 创建符合人体工程学的包装器",
    ["byteorder"] = "这个 crate 提供了以大端或小端顺序编码和解码数字的便捷方法",
    ["cc"] = "**cargo** 构建脚本的构建时依赖项，以协助调用本机 **C** 编译器将本机 **C** 代码编译成静态存档，以便链接到 **Rust** 代码。",
    ["chrono"] = "**Rust** 的日期和时间库",
    ["flate2"] = "deflate 压缩和解压缩公开为 read/buf 读/写流。支持 miniz oxide 和多个 zlib 实现。支持 zlib、gzip 和原始 deflate 流。",
    ["lazy_static"] = "一个宏，用于在 **Rust** 中声明延迟计算的静态变量。（该库已经废弃，在 **Rust** 1.70.0 版本开始，用 `use std::{cell::OnceCell, sync::OnceLock};` 取代）",
    ["num_cpus"] = "获取机器上的 cpu 数量。",
    ["opentelementry"] = "*open telemetry* 提供一组 api、库、代理和收集器服务来从您的应用程序捕获分布式跟踪和指标。您可以使用 prometheus、jaeger 和其他可观察性工具来分析它们。",
    ["parking_lot"] = "标准同步原语的更紧凑和高效的实现",
    ["plotters"] = "一个 **Rust** 绘图库，专注于 wasm 和本机应用程序的数据绘图",
    ["regex"] = "**Rust** 正则表达式的实现",
    ["thread_local"] = "每个线程对象本地存储",
    ["tower"] = "tower 是一个模块化和可重用组件库，用于构建强大的客户端和服务器。",
}
local str_parser = {
    ["base64"] = "将 base64 编码和解码为字节或 utf8",
    ["data-encoding"] = "高效且可自定义的数据编码函数，例如 base64、base32 和 hex",
    ["percent-encoding"] = "百分比编码和解码",
    ["unicode-segmentation"] = "这个板条箱根据 Unicode 标准附件 #29 规则提供字素簇、单词和句子边界。",
    ["unicode-width"] = "根据 unicode 标准附件 #11 规则确定 `char` 和 `str` 类型的显示宽度。",
}
local encoding = {
    ["dashmap"] = "用于 **Rust** 的超快并发哈希映射。",
    ["digest"] = "加密散列函数和消息认证码的特征",
    ["ring"] = "使用 **Rust** 的安全、快速、小型加密",
    ["serpent"] = "蛇块密码",
}
local fuzzy_find = {
    ["fuzzy-matcher"] = "模糊匹配库",
    ["simsearch"] = "一个简单而轻量级的模糊搜索引擎，在内存中工作，搜索相似的字符串（这里是双关语）。",
}
local render_text = {
    ["syntect"] = "使用 Sublime Text 语法实现高质量语法突出显示和代码智能的库",
    ["html2text"] = "将 **HTML** 渲染为纯文本。",
    ["pulldown-cmark-mdcat"] = "将 pulldown-cmark 事件渲染到 tty",
    ["pulldown-cmark"] = "通用标记的拉式解析器",
}
local log = {
    ["log"] = "**RUST** 的轻量级日志记录外观",
    ["env_logger"] = "通过环境变量配置的 `log` 的日志记录实现。",
    ["tracing"] = "**Rust** 的应用程序级跟踪。 log",
    ["tracing-subscriber"] = "用于实现和编写“跟踪”订阅者的实用程序。",
    ["tracing-appender"] = "为文件追加器和非阻塞编写器提供实用程序。",
    ["tracing-error"] = "通过“跟踪”丰富错误的实用程序。",
    ["tracing-log"] = "提供“tracing”和“log”包之间的兼容性。",
    ["structured-logger"] = "日志箱的日志记录实现，将同步或异步的结构化值以 json、cbor 或任何其他格式记录到文件、stderr、stdout 或任何其他目标中。",
    ["console-subscriber"] = "用于收集 tokio 控制台遥测数据的“tracing-subscriber::layer”。",
}
local file = {
    ["tempfile"] = "用于管理临时文件和目录的库。",
    ["dirs"] = "一个小型低级库，通过利用 Linux 上的 xdg 基本/用户目录规范（已知的文件夹 api）定义的机制，为 linux、windows、macos 和 redox 上的配置、缓存和其他数据提供特定于平台的标准目录位置在 Windows 上，以及在 Macos 上的标准目录指南。",
    ["glob"] = "支持根据 unix shell 样式模式匹配文件路径",
    ["memmap"] = "用于内存映射文件 io 的跨平台 **Rust** api",
    ["same_file"] = "一个简单的crate，用于确定两个文件路径是否指向同一个文件。",
    ["tar"] = "tar 文件读取器和写入器的 **Rust** 实现",
    ["walkdir"] = "递归地遍历一个目录。",
}
local img = {
    ["image"] = "用 **Rust** 编写的成像库。为最常见的图像格式提供基本的过滤器和解码器。",
    ["opencv"] = "opencv 的 **Rust** 绑定",
}
local performance = {
    ["criterion"] = "criterion.rs 通过快速准确地检测和测量性能改进或回归（即使是很小的改进）来帮助您编写快速代码。您可以自信地进行优化，了解每次更改如何影响代码的性能。",
    ["flame"] = "专为 **Rust** 打造的火焰图分析工具，可以告诉你程序在哪些代码上花费的时间过多，非常适合用于代码性能瓶颈的分析",
}
local math = {
    ["approx"] = "近似浮点相等比较和断言。",
    ["ndarray"] = "用于一般元素和数字的 n 维数组。轻量级数组视图和切片；视图支持分块和拆分。",
    ["num"] = "**Rust** 的数字类型和特征的集合，包括 *bigint*、*complex*、*rational*、范围迭代器、泛型整数等等！",
    ["num-complex"] = "**Rust** 的复数实现",
    ["rand"] = "该包提供了随机源",
    ["rand_distr"] = "从随机数分布中抽样",
    ["nalgebra"] = "具有变换和静态大小或动态大小矩阵的通用线性代数库。",
    ["sprs"] = "稀疏矩阵库",
    ["nalgebra-sparse"] = "基于nalgebra的稀疏矩阵计算。",
}
local web = {
    ["surf"] = "Surf the web - HTTP 客户端框架",
    ["graphql_client "] = "类型化 graphql 请求和响应",
    ["juniper"] = "graphql 服务器库",
    ["thirtyfour"] = "thirfyfour 是一个用于 **Rust** 的 selenium / web 驱动程序库，用于自动化网站 ui 测试。它支持完整的 w3c 网络驱动规范。",
    ["actix-web"] = "actix web 是一个强大、实用、速度极快的 **Rust** 网络框架",
    ["axum"] = "专注于人体工程学和模块化的网络框架",
    ["rocket"] = "专注于可用性、安全性、可扩展性和速度的 Web 框架。",
    ["salvo"] = "salvo 是一个强大而简单的 **Rust** Web 服务器框架。",
}
local channel = {
    ["async-channel"] = "异步多生产者多消费者通道(mpmc)",
    ["crossbeam"] = "并发编程的工具(mpmc)",
    ["flume"] = "一个极快的多生产者渠道(mpmc)",
}
local net = {
    ["openssl"] = "OpenSSL bindings",
    ["bytes"] = "处理字节的类型和特征",
    ["http"] = "一组用于表示 http 请求和响应的类型。",
    ["hyper"] = "快速正确的 **Rust** http 实现",
    ["ipgeolocate"] = "解析 ip 位置等信息",
    ["reqwest"] = "更高级别的 http 客户端库",
    ["robotstxt"] = "google 的 robots.txt 解析器和匹配器 C++ 库的本机 Rust 端口。",
    ["scraper"] = "**HTML** 解析 并使用 CSS 选择器查询",
    ["select"] = "一个从 **HTML** 文档中提取有用数据的库，适用于网络抓取。",
    ["socks5"] = "WIP",
    ["url"] = "**Rust** 的 **URL** 库，基于 WHATWG url 标准",
    ["warp"] = "以极快的速度提供网络服务",
}
local async = {
    ["actix"] = "**Rust** 的 Actor 框架",
    ["async-trait"] = "异步特征方法的类型擦除",
    ["async-std"] = "**Rust** 标准库的异步版本",
    ["futures"] = "零分配、可组合和类似迭代器接口的 futures 和 streams 实现",
    ["mio"] = "轻量级非阻塞 I/O。",
    ["pin-utils"] = "用于固定的实用程序",
    ["tokio"] = "一个事件驱动的、非阻塞的 I/O 平台，用于编写异步 I/O 支持的应用程序",
    ["tokio-graceful-shutdown"] = "对基于 tokio 的服务执行正常关闭的实用程序。",
    ["tokio-stream"] = "使用 `stream` 和 `tokio` 的实用程序。",
    ["tokio-test"] = "基于 tokio 和 future 的代码的测试实用程序",
}
local database = {
    ["metrics"] = "对数据库连接性能测试",
    ["mysql"] = "用 **Rust** 实现的 mysql 客户端库",
    ["mysql_async"] = "基于 tokio 的异步 mysql 客户端库。",
    ["postgres"] = "一个本地的、同步的 postgresql 客户端",
    ["redis_rs"] = "简单的redis客户端库",
    ["rusqlite"] = "符合人体工程学的 sqlite 包装器",
    ["sqlx"] = "**Rust** SQL 工具包。一个异步的、纯 **Rust** 的 sql crate，具有编译时检查查询而没有 dsl。支持 postgresql、mysql 和 sqlite。",
}
local orm = {
    ["diesel"] = "用于 postgresql、sqlite 和 mysql 的安全、可扩展的 orm 和查询构建器",
    ["rbs"] = "orm的序列化框架",
    ["rbatis"] = "**Rust** sql 工具包和 orm 库。一个异步的、纯 **Rust** 的 sql crate，具有编译时动态 sql",
    ["rbdc-mysql"] = "rust sql 工具包和 orm 库。一个异步、纯 **Rust** sql 箱，具有编译时动态 sql",
    ["rbdc-pg"] = "**Rust** sql 工具包和 orm 库。一个异步、纯 **Rust** sql 箱，具有编译时动态 sql",
    ["rbdc-sqlite"] = "**Rust** sql 工具包和 orm 库。一个异步、纯 **Rust** sql 箱，具有编译时动态 sql",
    ["rbdc-mssql"] = "**Rust** sql 工具包和 orm 库。一个异步、纯 **Rust** sql 箱，具有编译时动态 sql",
    ["rbdc-oracle"] = "一个简单的 rbatis 的 oracle 驱动程序",
    ["rbdc-tdengine"] = "rbatis 的 tdengine 驱动程序",
    ["sea-orm"] = "**Rust** 的异步和动态 orm",
    ["sea-orm-migration"] = "SeaORM 的迁移实用程序",
    ["sea-query"] = "用于 mysql、postgres 和 sqlite 的动态查询生成器。(sea-orm 包含了这个)",
}
local serde = {
    ["csv"] = "支持 serde 的快速 csv 解析。",
    ["jsonpath"] = "Rust 的 jsonpath",
    ["serde"] = "一个通用的序列化/反序列化框架",
    ["serde_json"] = "一种 json 序列化文件格式",
    ["serde_yaml"] = "serde 的 yaml 数据格式",
    ["toml"] = "toml 格式文件和流的本机 **Rust** 编码器和解码器。为 toml 数据提供标准序列化/反序列化特征的实现，以促进反序列化和序列化 **Rust** 结构。",
}
local error = {
    ["anyhow"] = "灵活的具体错误类型建立在 std::error::error 之上",
    ["thiserror"] = "推导（错误）",
    ["color-eyre"] = "一个用于恐慌的错误报告处理程序，以及用于为各种错误提供丰富多彩、一致且格式良好的错误报告的 eyre crate。",
    ["miette"] = "花哨的诊断报告库和协议，适合我们这些不是编译器黑客的凡人。",
}
local terminal = {
    ["inquire"] = "inquire 是一个用于在终端上构建交互式提示的库",
    ["colored"] = "在终端中添加颜色的最简单方法",
    ["ansi_term"] = "ansi 终端颜色和样式库（粗体、下划线）",
    ["clap"] = "一个简单易用、高效且功能齐全的命令行参数解析器",
    ["clap_complete"] = "为您的 clap::command 生成 shell 完成脚本",
    ["crossterm"] = "用于操作终端的跨平台终端库。",
    ["cursive"] = "一个专注于易用性的 tui（文本用户界面）库。",
    ["tui"] = "用于构建丰富的终端用户界面或仪表板的库(不积极维护)",
    ["ratatui"] = "用于构建丰富的终端用户界面或仪表板的库(fork from tui)",
    ["ansi-to-tui"] = "一个将 ansi 颜色编码文本转换为ratatouille库中的ratatouille::text::text类型的库",
    ["tuirealm"] = "一个用于构建 tui 界面的 tui-rs 框架，受到 React 和 Elm 的启发。",
    ["throbber-widgets-tui"] = "这是一个显示 throbber 的 tui-rs 小部件。",
    ["tui-image"] = "tui-rs 的图像查看器小部件",
    ["tui-textarea"] = "tui-textarea 是 tui-rs 的一个简单但功能强大的文本编辑器小部件。多行文本编辑器可以轻松地作为 tui 应用程序的一部分。",
}
local display = {
    ["prettytable-rs"] = "用于在终端中打印格式漂亮的表格的库",
    ["tabled"] = "一个易于使用的库，用于打印 Rust 结构和枚举的漂亮表格。",
}
local gui = {
    ["dioxus"] = "dioxus 可以轻松快速地使用 **Rust** 构建复杂的用户界面。任何 dioxus 应用程序都可以在 **Web** 浏览器中作为桌面应用程序、移动应用程序或任何其他地方运行，前提是您构建了正确的渲染器。",
    ["slint"] = "gui 工具包，可有效地为嵌入式设备和桌面应用程序开发流畅的图形用户界面",
    ["wayland-client"] = "绑定到 Wayland 协议的标准 c 实现，客户端",
    ["x11rb"] = "**Rust** 绑定到 X11",
}
local grpc = {
    ["tonic"] = "基于 http/2 的 grpc 实现侧重于高性能、互操作性和灵活性。",
    ["grpcio"] = "grpc的 **Rust** 语言实现，基于grpc c核心库。",
}
local quic = {
    ["quiche"] = "quic 传输协议和 http/3 的美味实现",
    ["quinn"] = "多功能快速传输协议实现",
}
local websocket = {
    ["tokio-tungstenite"] = "tokio 绑定 tungstenite，轻量级的基于流的 Web 套接字实现",
    ["tungstenite"] = "基于流的轻量级 Web 套接字实现",
}

local all = vim.tbl_deep_extend(
    "force",
    async,
    channel,
    crates,
    database,
    encoding,
    error,
    file,
    gui,
    img,
    log,
    math,
    net,
    performance,
    serde,
    terminal,
    web,
    render_text,
    orm,
    grpc,
    quic,
    fuzzy_find,
    str_parser,
    display
)
local snippets = {
    s(
        {
            trig = "release",
            priority = 30000,
            dscr = "发布配置",
        },
        fmt(
            [[
[profile.release]
opt-level = 3
lto = true

        ]],
            {}
        )
    ),
    s(
        {
            trig = "color-eyre-opt",
            priority = 30000,
            dscr = "优化color-eyre debug 性能",
        },
        fmt(
            [[
[profile.dev.package.backtrace]
opt-level = 3

        ]],
            {}
        )
    ),
}

for name, describe in pairs(all) do
    table.insert(
        snippets,
        s(
            {
                trig = name,
                priority = 30000,
                dscr = describe,
            },
            fmt(name .. [[ = { version = "<>" }]], {
                i(1, ""),
            }, { delimiters = "<>" })
        )
    )
end

return snippets
