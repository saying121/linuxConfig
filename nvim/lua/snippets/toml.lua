local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local serial = {
    ["mio-serial"] = "mio 的串行端口实现",
    ["serialport"] = "一个跨平台的低级串口库。",
    ["serialport5"] = "一个跨平台的底层串口库",
}

local transfer = {
    ["ocrs"] = "OCR engine",
    ["whisper-rs"] = "whisper.cpp 的 Rust 绑定",
}
local unix = {
    ["which"] = "rust 相当于 unix 命令“which”。在跨平台中找到已安装的可执行文件。",
    ["signal-hook-tokio"] = "tokio 对信号挂钩的支持",
    ["signal-hook"] = "Unix 信号处理",
    ["libc"] = "原始 FFI 绑定到 libc 等平台库。",
    ["dbus"] = "绑定到 d-bus，这是 Linux 上常用的用于进程间通信的总线。",
    ["linux-raw-sys"] = "为 linux 用户空间 api 生成绑定",
}
local os_crate = {
    ["rustix"] = "与 POSIX/Unix/Linux/Winsock 类系统调用的安全 Rust 绑定(uring,memory map,mount,pipe,libc)",
    ["open"] = "使用系统上配置的程序打开路径或 url",
    ["opener"] = "使用系统默认程序打开文件或链接。",
    ["num_cpus"] = "获取机器上的 cpu 数量。",
}
local machine_learning = {
    ["tensorflow"] = "tensorflow 的 Rust 语言绑定。",
}
local crates = {
    ["hashbrown"] = "谷歌 SwissTable hash map 的 Rust 端口",
    ["castaway"] = "针对有限编译时专业化的安全、零成本的向下转型。",
    ["rustyline"] = "rustyline，基于 antirez 的 linenoise 的 readline 实现",
    ["owning_ref"] = "一个用于创建携带其所有者的引用的库。",
    ["shared_memory"] = "一个用户友好的包，允许您在进程之间共享内存",
    ["contest-algorithms"] = "编程竞赛的常用算法和数据结构",
    ["strum"] = "用于处理枚举和字符串的有用宏",
    ["ilhook"] = "提供在 x86 和 x86_64 架构中内联挂钩二进制代码的方法的库",
    ["device_query"] = "一个基本库，用于在没有窗口的情况下按需查询键盘和鼠标状态。",
    ["tendril"] = "用于零拷贝解析的紧凑缓冲区/字符串类型",
    ["defer-drop"] = "推迟将大型类型删除到后台线程",
    ["derive_builder"] = "派生 **Rust** 结构的构建器实现",
    ["semver"] = "用于Cargo语义版本控制风格的解析器和评估器",
    ["get-cookie"] = "从本地浏览器的 cookie 存储中获取 cookie",
    ["cookie"] = "http cookie 解析和 cookie jar 管理。支持签名和私有（加密、验证）jar。",
    ["GraphQL"] = "rust lang 的 graphql 参考实现。",
    ["bitflags"] = "一个类型安全的位掩码标志生成器，对 **C** 风格标志集很有用。它可用于围绕 **C** api 创建符合人体工程学的包装器",
    ["byteorder"] = "这个 crate 提供了以大端或小端顺序编码和解码数字的便捷方法",
    ["flate2"] = "deflate 压缩和解压缩公开为 read/buf 读/写流。支持 miniz oxide 和多个 zlib 实现。支持 zlib、gzip 和原始 deflate 流。",
    ["lazy_static"] = [[一个宏，用于在 **Rust** 中声明延迟计算的静态变量。
    （该库已经废弃
    用 `std::{cell::OnceCell, sync::OnceLock};
    std::{sync::LazyLock, cell::LazyCell}}` 取代）]],
    ["opentelementry"] = "*open telemetry* 提供一组 api、库、代理和收集器服务来从您的应用程序捕获分布式跟踪和指标。您可以使用 prometheus、jaeger 和其他可观察性工具来分析它们。",
    ["tower"] = "tower 是一个模块化和可重用组件库，用于构建强大的客户端和服务器。",
    ["closure_attr"] = "用于简化闭包捕获的属性宏",
}
local util = {
    ["cfg-if"] = "根据大量 #[cfg] 参数以符合人体工程学的方式定义项目的宏。其结构类似于 if-else 链，第一个匹配的分支是发出的项目。",
    ["indoc"] = "缩进文档文字",
    ["hex-literal"] = "用于在编译时将十六进制字符串转换为字节数组的宏",
    ["atoi"] = "直接从安全代码中的 `[u8]` 切片解析整数",
    ["captcha"] = "用于生成验证码的库。",
    ["sscanf"] = "基于正则表达式的 sscanf（格式反转！()）宏",
    ["regex"] = "**Rust** 正则表达式的实现",
    ["grep-searcher"] = "作为库的快速面向行正则表达式搜索。",
    ["grep-regex"] = "将 rust 的正则表达式库与“grep”板条箱一起使用。",
    ["ignore"] = "一个快速库，用于有效地将忽略文件（例如`.gitignore`）与文件路径匹配。",
    ["imara-diff"] = "最小的 terminfo 库。",
}
local parser = {
    ["nom"] = "面向字节、零拷贝、解析器组合器库",
    ["lalrpop"] = "方便的 lr(1) 解析器生成器",
    ["peg"] = "一个简单的解析表达式语法（peg）解析器生成器。",
    ["pest"] = "优雅的解析器",
}
local some_display = {
    ["parse-display"] = "使用通用设置实现显示和 str 的程序宏。",
    ["custom-format"] = "Rust 的自定义格式。",
}
local iterators = {
    ["rev_lines"] = "rust 迭代器用于逐行读取文件并反向读取缓冲区",
    ["itertools"] = "额外的迭代器适配器、迭代器方法、自由函数和宏。",
}
local algorithms = {
    ["raft"] = "raft算法的Rust语言实现。",
    ["bio"] = [[Rust 的生物信息学库。该库提供了许多算法和数据结构的实现，
        这些算法和数据结构对生物信息学以及其他领域都很有用。]],
    ["rustgym"] = "rustgym 解决方案",
    ["rust-algorithms"] = "一个 Rust 算法库",
}
local perf = {
    ["mimalloc"] = "面向性能和安全的嵌入式分配器",
    ["tikv-jemallocator"] = "由 jemalloc 支持的 Rust 分配器",
}
local arena = {
    ["bumpalo"] = "Rust 的快速 arena 分配舞台。",
    ["typed-arena"] = "arena，一种快速但有限的分配器类型",
    ["id-arena"] = "一个简单的、基于 id 的 arena。",
    ["generational-arena"] = "一个安全的 arena 分配器，通过使用分代索引支持删除，而不会遇到 ABA 问题。",
}
local date_time = {
    ["chrono"] = "**Rust** 的日期和时间库",
    ["time"] = "日期和时间库。与标准库完全互操作。大部分与#![无标准]兼容。",
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
local find_match = {
    ["fuzzy-matcher"] = "模糊匹配库",
    ["simsearch"] = "一个简单而轻量级的模糊搜索引擎，在内存中工作，搜索相似的字符串（这里是双关语）。",
    ["nucleo-matcher"] = "即插即用高性能模糊匹配器",
    ["nucleo"] = "即插即用高性能模糊匹配器",
    ["memchr"] = "提供极其快速的（在 x86_64、aarch64 和 wasm32 上使用 simd）例程，用于 1、2 或 3 字节搜索和单个子字符串搜索。",
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
    ["tempdir"] = "用于管理临时目录并在删除时删除所有内容的库。",
    ["dirs"] = [[一个小型低级库，通过利用 Linux 上的 xdg 基本/用户目录规范（已知的文件夹 api）定义的机制，
    为 linux、windows、macos 和 redox 上的配置、缓存和其他数据提供特定于平台的标准目录位置
    在 Windows 上，以及在 Macos 上的标准目录指南。]],
    ["directories"] = [[一个小型中级库，通过利用 Linux 上的 xdg 基本/用户目录规范（Windows 上已知的文件夹 api）定义的机制，
    为 Linux、Windows 和 MacOS 上的配置、缓存和其他数据提供特定于平台的标准目录位置，
    以及 macos 上的标准目录指南。]],
    ["glob"] = "支持根据 unix shell 样式模式匹配文件路径",
    ["memmap2"] = "用于内存映射文件 io 的跨平台 **Rust** api",
    ["same_file"] = "一个简单的crate，用于确定两个文件路径是否指向同一个文件。",
    ["tar"] = "tar 文件读取器和写入器的 **Rust** 实现",
    ["walkdir"] = "递归地遍历一个目录。",
    ["dunce"] = "将 Windows 路径标准化为最兼容的格式，尽可能避免 unc",
}
local img = {
    ["plotters"] = "一个 **Rust** 绘图库，专注于 wasm 和本机应用程序的数据绘图",
    ["image"] = "用 **Rust** 编写的成像库。为最常见的图像格式提供基本的过滤器和解码器。",
    ["opencv"] = "opencv 的 **Rust** 绑定",
}
local benchmark = {
    ["criterion"] = "criterion.rs 通过快速准确地检测和测量性能改进或回归（即使是很小的改进）来帮助您编写快速代码。您可以自信地进行优化，了解每次更改如何影响代码的性能。",
    ["flame"] = "专为 **Rust** 打造的火焰图分析工具，可以告诉你程序在哪些代码上花费的时间过多，非常适合用于代码性能瓶颈的分析",
    ["inferno"] = "火焰图性能分析工具套件的 Rust 端口",
    ["pprof"] = "用于 Rust 程序的内部性能工具。",
}
local maths = {
    ["cgmath"] = "用于计算机图形学的线性代数和数学库。",
    ["approx"] = "近似浮点相等比较和断言。",
    ["ndarray"] = "用于一般元素和数字的 n 维数组。轻量级数组视图和切片；视图支持分块和拆分。",
    ["num"] = "**Rust** 的数字类型和特征的集合，包括 *bigint*、*complex*、*rational*、范围迭代器、泛型整数等等！",
    ["num-complex"] = "**Rust** 的复数实现",
    ["rand"] = "该包提供了随机源",
    ["rand_distr"] = "从随机数分布中抽样",
    ["nalgebra"] = "具有变换和静态大小或动态大小矩阵的通用线性代数库。",
    ["sprs"] = "稀疏矩阵库",
    ["nalgebra-sparse"] = "基于nalgebra的稀疏矩阵计算。",
    ["rug"] = "基于 gmp、mpfr 和 mpc 的任意精度整数、有理数、浮点和复数",
}
local web = {
    ["surf"] = "Surf the web - HTTP 客户端框架",
    ["graphql_client"] = "类型化 graphql 请求和响应",
    ["juniper"] = "graphql 服务器库",
    ["thirtyfour"] = "thirfyfour 是一个用于 **Rust** 的 selenium / web 驱动程序库，用于自动化网站 ui 测试。它支持完整的 w3c 网络驱动规范。",
    ["actix-web"] = "actix web 是一个强大、实用、速度极快的 **Rust** 网络框架",
    ["axum"] = "专注于人体工程学和模块化的网络框架",
    ["rocket"] = "专注于可用性、安全性、可扩展性和速度的 Web 框架。",
    ["salvo"] = "salvo 是一个强大而简单的 **Rust** Web 服务器框架。",
}
local ciphers = {
    -- block ciphers
    ["aes"] = "高级加密标准的纯 Rust 实现（又名 rijndael）",
    ["aria"] = "aria 加密算法的纯 Rust 实现",
    ["belt-block"] = "带块分组密码实现",
    ["blowfish"] = "河豚分组密码",
    ["camellia"] = "山茶花分组密码",
    ["cast5"] = "cast5 分组密码",
    ["cast6"] = "cast6 分组密码",
    ["des"] = "des 和三重 des (3des, tdes) 分组密码实现",
    ["idea"] = "idea 分组密码",
    ["kuznyechik"] = "kuznyechik (gost r 34.12-2015) 分组密码",
    ["magma"] = "Magma  (Gost R 34.12-2015) 分组密码",
    ["rc2"] = "rc2 分组密码",
    ["rc5"] = "rc5 分组密码",
    ["serpent"] = "蛇块密码",
    ["sm4"] = "sm4 分组密码算法",
    ["speck"] = "Speck 分组密码算法",
    ["threefish"] = "Threefish 分组密码",
    ["twofish"] = "Twofish 分组密码",

    -- block modes
    ["cbc"] = "密码块链接 (cbc) 块密码操作模式",
    ["belt-ctr"] = "皮带标准规定的 ctr 块操作模式",
    ["cfb8"] = "具有八位反馈的密码反馈 (cfb-8) 分组密码操作模式",
    ["cfb-mode"] = "密码反馈 (cfb) 分组密码操作模式",
    ["ctr"] = "ctr 块操作模式",
    ["ige"] = "无限乱码扩展 (ige) 分组密码操作模式",
    ["ofb"] = "输出反馈][ofb] (ofb) 分组密码操作模式",
    ["pcbc"] = "传播密码块链接 (pcbc) 块密码操作模式",

    -- hashes
    ["ascon-hash"] = "ascon 和 ascona 哈希和 xofs 的实现",
    ["belt-hash"] = "BelT 哈希函数（stb 34.101.31-2020）",
    ["blake2"] = "BLAKE2 散列函数",
    ["fsb"] = "FSB hash function",
    ["gost94"] = "GOST R 34.11-94 哈希函数",
    ["groestl"] = "Grøstl 哈希函数",
    ["jh"] = "jh 加密哈希函数的纯 Rust 实现",
    ["k12"] = "KangarooTwelve(袋鼠十二) 哈希函数的纯 Rust 实现",
    ["md2"] = "MD2 哈希函数",
    ["md4"] = "MD4 哈希函数",
    ["md-5"] = "MD5 哈希函数",
    ["ripemd"] = "ripemd 哈希函数的纯 Rust 实现",
    ["sha1"] = "SHA-1 哈希函数",
    ["sha2"] = "sha-2 哈希函数系列的纯 Rust 实现，包括 sha-224、sha-256、sha-384 和 sha-512。",
    ["sha3"] = [[
    sha-3 的纯 Rust 实现，是一系列基于 keccak 的哈希函数，
    包括eXtendable-Output Functions (XOFs) (xofs) 的 shake 系列，以及加速变体 TurboSHAKE
    ]],
    ["shabal"] = "Shabal 哈希函数",
    ["skein"] = "Skein 哈希函数",
    ["sm3"] = "SM3 (OSCCA GM/T 0004-2012) 哈希函数",
    ["streebog"] = "Streebog (GOST R 34.11-2012) 哈希函数",
    ["tiger"] = "Tiger 哈希函数",
    ["whirlpool"] = "Whirlpool 哈希函数",

    -- password-hashes
    ["argon2"] = "argon2 密码哈希函数的纯 Rust 实现，支持 argon2d、argon2i 和 argon2id 算法变体",
    ["balloon-hash"] = "Balloon password 哈希函数的纯 Rust 实现",
    ["bcrypt-pbkdf"] = "bcrypt-pbkdf 基于密码的密钥导出函数",
    ["password-auth"] = "Password authentication 库，注重简单性和易用性，包括对 argon2、pbkdf2 和 scrypt 密码哈希算法的支持",
    ["pbkdf2"] = "pbkdf2 的通用实现",
    ["scrypt"] = "scrypt 基于密码的密钥派生函数",
    ["sha-crypt"] = "基于 sha-512 的 sha-crypt 密码哈希的纯 Rust 实现，由 posix crypt c 库实现",

    ["crypto"] = "所有 rust 加密特征的外观板条箱（例如“aead”、“cipher”、“digest”）",
    ["ring"] = "使用 Rust 的安全、快速、小型加密货币。",
    ["openssl"] = "OpenSSL bindings",
    ["secret-service"] = "与秘密服务 API 接口的库",
}
local net = {
    ["rustls"] = "rustls 是一个用 **Rust** 编写的现代 tls 库。",
    ["keyring"] = "用于管理密码/凭据的跨平台库",
    ["http"] = "一组用于表示 **HTTP** 请求和响应的类型。",
    ["hyper"] = "快速正确的 **Rust** **HTTP** 实现",
    ["ipgeolocate"] = "解析 ip 位置等信息",
    ["reqwest"] = "更高级别的 **HTTP** 客户端库",
    ["robotstxt"] = "google 的 robots.txt 解析器和匹配器 C++ 库的本机 Rust 端口。",
    ["scraper"] = "**HTML** 解析 并使用 CSS 选择器查询",
    ["soup"] = "受到 python 库 beautiful soup 的启发，这是 html5ever 之上的一层，添加了不同的 api 用于查询和操作 html",
    ["html5ever"] = "高性能浏览器级 **HTML5** 解析器",
    ["select"] = "一个从 **HTML** 文档中提取有用数据的库，适用于网络抓取。",
    ["socks5"] = "WIP",
    ["url"] = "**Rust** 的 **URL** 库，基于 WHATWG url 标准",
    ["warp"] = "以极快的速度提供网络服务",
}
local threads = {
    ["thread_local"] = "每个线程对象本地存储",
    ["crossbeam"] = "并发编程的工具(mpmc)",
    ["flume"] = "一个极快的多生产者渠道(mpmc)",
    ["parking"] = "线程 parking and unparking",
    ["rayon"] = "**Rust** 一个数据并行库，它可以让你轻松地把顺序计算转换成并行计算，并且保证没有数据竞争。它根据运行时的工作负载自动调整并行度。",
    ["raw_sync"] = "操作系统同步原语的轻量级包装器",
    ["parking_lot"] = "标准同步原语的更紧凑和高效的实现",
    ["spin"] = "基于自旋的同步原语",
    ["threadpool"] = "用于在一组固定的工作线程上运行多个作业的线程池。",
}
local async = {
    ["monoio"] = "基于 iouring 的每个核心运行时一个线程。",
    ["async-channel"] = "异步多生产者多消费者通道(mpmc)",
    ["trait-variant"] = "用于处理 Rust 中的 impl 特征的实用程序",
    ["async-once-cell"] = "异步单赋值单元格和惰性值。",
    ["async-lazy"] = "第一次访问时使用异步函数初始化的值。",
    ["smol"] = "一个小而快速的异步运行时",
    ["async-recursion"] = "异步函数的递归",
    ["pollster"] = "阻塞同步线程直到 future 完成",
    ["cassette"] = "一个简单的、单一未来的、非阻塞的执行器，用于构建状态机",
    ["actix"] = "**Rust** 的 Actor 框架",
    ["async-trait"] = "异步特征方法的类型擦除",
    ["async-std"] = "**Rust** 标准库的异步版本",
    ["futures"] = "零分配、可组合和类似迭代器接口的 `futures` 和 `streams` 实现",
    ["futures-io"] = "futures-rs 库的 `AsyncRead` 、 `AsyncWrite` 、 `AsyncSeek` 和 `AsyncBufRead` 特征。",
    ["mio"] = "轻量级非阻塞 I/O。",
    ["pin-utils"] = "用于固定的实用程序",
    ["tokio"] = "一个事件驱动的、非阻塞的 I/O 平台，用于编写异步 I/O 支持的应用程序",
    ["tokio-graceful-shutdown"] = "对基于 `tokio` 的服务执行正常关闭的实用程序。",
    ["tokio-graceful"] = "用于正常关闭 tokio 应用程序的 util",
    ["tokio-stream"] = "使用 `stream` 和 `tokio` 的实用程序。",
    ["tokio-test"] = "基于 `tokio` 和 `future` 的代码的测试实用程序",
    ["tokio-serde"] = "使用 tokio 通过网络发送和接收 serde 可编码类型。该库用作序列化格式特定库的构建块。",
    ["tokio-uring"] = "io-uring 对 tokio 异步运行时的支持。",
    ["io-uring"] = "Rust 的低级`io uring`用户空间接口",
    ["async-lock"] = "异步同步原语",
    ["pin-project-lite"] = "用声明性宏编写的 pin-project 的轻量级版本。",
    ["async-stream"] = "使用 async & wait 表示法的异步流",

    ["polling"] = "便携式接口 epoll, kqueue, event ports, and IOCP",
    ["miow"] = "Windows 的零开销 I/O 库，专注于 iocp 和异步 I/O 抽象。",
    ["async-io"] = "异步 I/O 和定时器",
    ["async-net"] = "用于 TCP/UDP/Unix 通信的异步网络原语",
    ["async-fs"] = "异步文件系统原语",
    ["futures-lite"] = "Futures, streams, and async I/O 组合器",
}
local database = {
    ["metrics"] = "对数据库连接性能测试",
    ["mysql"] = "用 **Rust** 实现的 mysql 客户端库",
    ["mysql_async"] = "基于 `tokio` 的异步 mysql 客户端库。",
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
    ["rustis"] = "用于 Rust 的 Redis 异步驱动程序",
}
local serde = {
    ["csv"] = "支持 serde 的快速 csv 解析。",
    ["jsonpath"] = "Rust 的 jsonpath",
    ["serde"] = "一个通用的序列化/反序列化框架",
    ["serde_json"] = "一种 json 序列化文件格式",
    ["rkyv"] = "Rust 的零拷贝反序列化框架",
    ["rmp_serde"] = "rmp 的 serde 绑定",
    ["ser-raw"] = [[简单快速的序列化器
                    文档数据:
                    serde_json: 226.99 µs
                    rkyv:        44.98 µs
                    ser_raw:     14.35 µs]],
    ["serde_yaml"] = "serde 的 yaml 数据格式",
    ["toml"] = "toml 格式文件和流的本机 **Rust** 编码器和解码器。为 toml 数据提供标准序列化/反序列化特征的实现，以促进反序列化和序列化 **Rust** 结构。",
    ["ini"] = "一个建立在 configparser 之上的简单宏，用于加载和解析 ini 文件。您可以使用它来编写最终用户可以轻松定制的 Rust 程序。",
    ["serde_ini"] = "windows ini 文件 {de,}序列化",
    ["bincode"] = "用于将结构转换为字节的二进制序列化/反序列化策略，反之亦然！",
    ["serde-this-or-that"] = "可以指定为多种类型的字段的自定义反序列化。",
    ["serde_bytes"] = "Serde 的 `&[u8]` 和 `vec<u8>` 的优化处理",
}
local error = {
    ["anyhow"] = "灵活的具体错误类型建立在 std::error::error 之上",
    ["thiserror"] = "推导（错误）",
    ["color-eyre"] = "一个用于恐慌的错误报告处理程序，以及用于为各种错误提供丰富多彩、一致且格式良好的错误报告的 eyre crate。",
    ["miette"] = "花哨的诊断报告库和协议，适合我们这些不是编译器黑客的凡人。",
    ["better-panic"] = "非常漂亮的回溯受到 python 回溯的启发。",
    ["human-panic"] = "给人类的恐慌信息",
    ["pretty_assertions"] = "使用直接替换覆盖 `assert eq!` 和 `assert ne!`，添加丰富多彩的差异。",
}
local terminal = {
    ["owo-colors"] = "零分配的终端颜色会让人们惊叹不已",
    ["terminal_size"] = "获取 Linux 或 Windows 终端的大小",
    ["atty"] = "一个简单的查询 atty 的接口,你是还是不是 tty？",
    ["indicatif"] = "Rust 的进度条和 cli 报告库",
    ["kdam"] = "Rust 的控制台进度条库。 （受到 tqdm 和 rich.progress 的启发）",
    ["inquire"] = "inquire 是一个用于在终端上构建交互式提示的库",
    ["colored"] = "在终端中添加颜色的最简单方法",
    ["ansi_term"] = "ansi 终端颜色和样式库（粗体、下划线）",
    ["clap"] = "一个简单易用、高效且功能齐全的命令行参数解析器",
    ["clap_complete"] = "为您的 clap::command 生成 shell 完成脚本",
    ["figlet-rs"] = "Rust 实现 Figlet 来创建 ASCII 艺术",

    ["keymap"] = "用于从配置解析终端输入事件的库",

    ["crossterm"] = "用于操作终端的跨平台终端库。",
    ["cursive"] = "一个专注于易用性的 tui（文本用户界面）库。",
    ["ratatui"] = "用于构建丰富的终端用户界面或仪表板的库(fork from tui)",
    ["ansi-to-tui"] = "一个将 ansi 颜色编码文本转换为ratatouille库中的ratatouille::text::text类型的库",
    ["tuirealm"] = "一个用于构建 tui 界面的 tui-rs 框架，受到 React 和 Elm 的启发。",
    ["throbber-widgets-tui"] = "这是一个显示 throbber 的 tui-rs 小部件。",
    ["tui-image"] = "tui-rs 的图像查看器小部件",
    ["ratatui-image"] = "ratatui 的图像小部件，支持 Sixels 和 unicode-halfblocks",
    ["tui-textarea"] = "tui-textarea 是 tui-rs 的一个简单但功能强大的文本编辑器小部件。多行文本编辑器可以轻松地作为 tui 应用程序的一部分。",
    ["tui-term"] = "ratatui 的伪终端小部件",
    ["tui-input"] = "支持多个后端的 tui 输入库",
    ["tui-tree-widget"] = "tui-rs 的树小部件",
    ["tui-logger"] = "tui crate 智能小部件的 logger",
    ["tui-big-text"] = "一个简单的ratatui小部件，用于在tui（终端用户界面）中使用 font8x8 crate 显示大文本。",
    ["color-to-tui"] = [[解析颜色并将其转换为 `ratatui::style::colors`
    * #C3F111 -> Color::Rgb(195,241,17)
    * #CFB -> Color::Rgb(204,255,187)
    * 142 -> Color::Indexed(142)
    ]],
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
    ["iced"] = "受 Elm 启发的跨平台 GUI 库",
}
local grpc = {
    ["tonic"] = "基于 http/2 的 grpc 实现侧重于高性能、互操作性和灵活性。",
    ["grpcio"] = "grpc的 **Rust** 语言实现，基于grpc c核心库。",
    ["tarpc"] = "一个 rust 的 rpc 框架，重点是易用性。",
    ["volo"] = "volo是一个高性能、可扩展性强的rust rpc框架，帮助开发者构建微服务。",
    ["prost"] = "Rust 语言的Protocol Buffers实现。",
    ["pilota"] = "Pilota 是纯 Rust 中的 thrift 和 protobuf 实现，具有高性能和可扩展性。",
}
local quic = {
    ["quiche"] = "quic 传输协议和 http/3 的美味实现",
    ["quinn"] = "多功能快速传输协议实现",
}
local websocket = {
    ["tokio-tungstenite"] = "tokio 绑定 tungstenite，轻量级的基于流的 Web 套接字实现",
    ["tungstenite"] = "基于流的轻量级 Web 套接字实现",
}
local macro = {
    ["darling"] = "一个 proc-macro 库，用于在实现自定义派生时将属性读取到结构中。",
    ["macro_railroad"] = "一个为 Rust 宏生成语法图的库",
    ["quote"] = "准引用宏引用！(...)",
    ["syn"] = "基于流的轻量级 Web 套接字实现",
    ["paste"] = "满足您所有标记粘贴需求的宏",
    ["casey"] = "ident 令牌的大小写转换宏",
    ["parsel"] = "使用 ast 节点类型作为语法的零代码解析器生成",
}
local bindings = {
    ["bindgen"] = "自动生成 rust ffi 到 c 和 c++ 库的绑定。",
    ["inline-python"] = "直接在 **Rust** 代码中内联 **Python** 代码",
    ["pyo3"] = "绑定到 python 解释器",
    ["xshell"] = "在 Rust 中快速编写 shell 脚本的实用程序",
    ["rlua"] = "与 lua 5.x 的高级绑定",
    ["mlua"] = [[与 lua 5.4/5.3/5.2/5.1（包括 luajit）和 roblox luau 的高级绑定
        ，具有 async/await 功能，并支持在 Rust 中编写本机 lua 模块。]],
    ["factorio-mlua"] = [[与Lua 5.4/5.3/5.2/5.1（包括LuaJIT）和Roblox-Luau的高级绑定，
        具有 async/await 功能，并支持在Rust中编写本地Lua模块。添加Factorio Lua支持的 fork。]],
}
local libs = {
    ["hot-lib-reloader"] = "用于在更改时重新加载库的实用程序。以获得更快的反馈周期。",
    ["libloading"] = "围绕平台动态库加载原语的绑定，大大提高了内存安全性。",
    ["libloader"] = "一个基于 libloading 的易于使用的 rust dll 加载器",
    ["dlib"] = "用于处理手动加载可选系统库的辅助宏。",
    ["abi_stable"] = "用于进行 rust-to-rust ffi，编写在程序启动时加载的库。",
    ["cc"] = "**cargo** 构建脚本的构建时依赖项，以协助调用本机 **C** 编译器将本机 **C** 代码编译成静态存档，以便链接到 **Rust** 代码。",
}
local neovim = {
    ["nvim-oxi"] = "Rust 与 Neovim 的所有事物绑定",
}
local notify = {
    ["notify-rust"] = "显示桌面通知（linux、bsd、mac）。纯 Rust dbus 客户端和服务器。",
    ["notify"] = "跨平台文件系统通知库",
}
local test = {
    ["skeptic"] = "通过 Cargo 测试你的 Rust Markdown 文档",
}
local data_struct = {
    ["arrayvec"] = "具有固定容量的向量，由数组支持（它也可以存储在堆栈上）。实现固定容量数组 vec 和数组 string。",
    ["arcstr"] = "更好的引用计数字符串类型，对字符串文字和引用计数子字符串提供零成本（免分配）支持。",
    ["beef"] = "更紧凑的牛",
    ["bytemuck"] = "一个用来处理成堆字节的箱子。",
    ["smol_str"] = "使用 o(1) 克隆的小字符串优化字符串类型",
    ["bytes"] = "处理字节的类型和特征",
    ["smallvec"] = "“小向量”优化：在堆栈上存储最多少量的项目",
    ["smallstr"] = "基于smallvec的字符串容器",
    ["tinyvec"] = "`tinyvec` 提供 100% 安全的类 vec 数据结构。",
    ["tendril"] = "用于零拷贝解析的紧凑缓冲区/字符串类型",
}

local all = vim.tbl_deep_extend(
    "force",
    test,
    data_struct,
    async,
    threads,
    crates,
    database,
    encoding,
    error,
    file,
    gui,
    img,
    log,
    maths,
    net,
    benchmark,
    serde,
    terminal,
    web,
    render_text,
    orm,
    grpc,
    quic,
    find_match,
    str_parser,
    display,
    date_time,
    perf,
    macro,
    bindings,
    websocket,
    libs,
    algorithms,
    ciphers,
    arena,
    iterators,
    neovim,
    notify,
    some_display,
    parser,
    transfer,
    util,
    unix,
    os_crate,
    machine_learning,
    serial
)
-- [package.metadata.wasm-pack.profile.release]
-- wasm-opt = ['-Os']
local snippets = {
    s(
        {
            trig = "linux_linker",
            priority = 30000,
            dscr = "发布配置",
        },
        fmt(
            [[
[target.x86_64-unknown-linux-gnu]
linker = "clang"
rustflags = ["-C", "link-arg=-fuse-ld=mold"]

        ]],
            {}
        )
    ),
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
strip = true
codegen-units = 1
panic = "abort"

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
    s(
        {
            trig = "clippy_lints_workspace",
            priority = 30000,
            dscr = "extra clippy lints",
        },
        fmt(
            [[
[workspace.lints.clippy]
# string_slice                              = "warn"
# panic                                     = "warn"
unseparated_literal_suffix                = "warn"
str_to_string                             = "warn"
string_add_assign                         = "warn"
string_lit_as_bytes                       = "warn"
string_to_string                          = "warn"
inefficient_to_string                     = "warn"
manual_string_new                         = "warn"
needless_raw_strings                      = "warn"
filter_map_next                           = "warn"
flat_map_option                           = "warn"
map_err_ignore                            = "warn"
map_unwrap_or                             = "warn"
zero_sized_map_values                     = "warn"
maybe_infinite_iter                       = "warn"
from_iter_instead_of_collect              = "warn"
iter_not_returning_iterator               = "warn"
iter_on_empty_collections                 = "warn"
iter_on_single_items                      = "warn"
iter_with_drain                           = "warn"
let_underscore_untyped                    = "warn"
useless_let_if_seq                        = "warn"
equatable_if_let                          = "warn"
bool_to_int_with_if                       = "warn"
if_not_else                               = "warn"
if_then_some_else_none                    = "warn"
manual_assert                             = "warn"
manual_clamp                              = "warn"
manual_instant_elapsed                    = "warn"
manual_let_else                           = "warn"
manual_ok_or                              = "warn"
decimal_literal_representation            = "warn"
unreadable_literal                        = "warn"
redundant_clone                           = "warn"
redundant_else                            = "warn"
redundant_feature_names                   = "warn"
redundant_pub_crate                       = "warn"
unwrap_in_result                          = "warn"
unnecessary_safety_doc                    = "warn"
doc_link_with_quotes                      = "warn"
doc_markdown                              = "warn"
empty_line_after_doc_comments             = "warn"
alloc_instead_of_core                     = "warn"
allow_attributes                          = "warn"
allow_attributes_without_reason           = "warn"
checked_conversions                       = "warn"
as_underscore                             = "warn"
branches_sharing_code                     = "warn"
case_sensitive_file_extension_comparisons = "warn"
clear_with_drain                          = "warn"
collection_is_never_read                  = "warn"
copy_iterator                             = "warn"
create_dir                                = "warn"
debug_assert_with_mut_call                = "warn"
default_union_representation              = "warn"
deref_by_slicing                          = "warn"
derive_partial_eq_without_eq              = "warn"
disallowed_script_idents                  = "warn"
float_cmp                                 = "warn"
float_cmp_const                           = "warn"
lossy_float_literal                       = "warn"
explicit_deref_methods                    = "warn"
explicit_into_iter_loop                   = "warn"
explicit_iter_loop                        = "warn"
rc_buffer                                 = "warn"
rc_mutex                                  = "warn"
mutex_atomic                              = "warn"
mutex_integer                             = "warn"
invalid_upcast_comparisons                = "warn"
linkedlist                                = "warn"
match_bool                                = "warn"
match_on_vec_items                        = "warn"
match_wild_err_arm                        = "warn"
needless_bitwise_bool                     = "warn"
needless_collect                          = "warn"
needless_continue                         = "warn"
needless_for_each                         = "warn"
needless_pass_by_value                    = "warn"
range_minus_one                           = "warn"
range_plus_one                            = "warn"
semicolon_if_nothing_returned             = "warn"
semicolon_inside_block                    = "warn"
semicolon_outside_block                   = "warn"
stable_sort_primitive                     = "warn"
unnecessary_box_returns                   = "warn"
unnecessary_join                          = "warn"
unnecessary_safety_comment                = "warn"
unnecessary_self_imports                  = "warn"
unnecessary_struct_initialization         = "warn"
unnecessary_wraps                         = "warn"
cloned_instead_of_copied                  = "warn"
unused_async                              = "warn"
unused_peekable                           = "warn"
unused_rounding                           = "warn"
unused_self                               = "warn"
use_self                                  = "warn"
verbose_file_reads                        = "warn"
verbose_bit_mask                          = "warn"
unneeded_field_pattern                    = "warn"
unnested_or_patterns                      = "warn"
type_repetition_in_bounds                 = "warn"
unchecked_duration_subtraction            = "warn"
unicode_not_nfc                           = "warn"
missing_const_for_fn                      = "warn"
mut_mut                                   = "warn"
filetype_is_file                          = "warn"
readonly_write_lock                       = "warn"
try_err                                   = "warn"
same_functions_in_if_condition            = "warn"
same_name_method                          = "warn"
large_digit_groups                        = "warn"
large_futures                             = "warn"
large_include_file                        = "warn"
large_stack_arrays                        = "warn"
large_stack_frames                        = "warn"
large_types_passed_by_value               = "warn"
index_refutable_slice                     = "warn"
mem_forget                                = "warn"
empty_drop                                = "warn"
empty_line_after_outer_attr               = "warn"
empty_structs_with_brackets               = "warn"
empty_enum                                = "warn"
enum_glob_use                             = "warn"
error_impl_error                          = "warn"
exit                                      = "warn"
ignored_unit_patterns                     = "warn"
trait_duplication_in_bounds               = "warn"
default_trait_access                      = "warn"
impl_trait_in_params                      = "warn"
trivial_regex                             = "warn"
trivially_copy_pass_by_ref                = "warn"
cast_ptr_alignment                        = "warn"
borrow_as_ptr                             = "warn"
as_ptr_cast_mut                           = "warn"
clone_on_ref_ptr                          = "warn"
ptr_as_ptr                                = "warn"
ptr_cast_constness                        = "warn"
transmute_ptr_to_ptr                      = "warn"
panic_in_result_fn                        = "warn"
suboptimal_flops                          = "warn"
should_panic_without_expect               = "warn"
significant_drop_tightening               = "warn"
pub_without_shorthand                     = "warn"
ref_binding_to_reference                  = "warn"
ref_option_ref                            = "warn"
ref_patterns                              = "warn"
rest_pat_in_fully_bound_structs           = "warn"
implicit_hasher                           = "warn"
implicit_clone                            = "warn"
macro_use_imports                         = "warn"
many_single_char_names                    = "warn"
mismatching_type_param_order              = "warn"
transmute_undefined_repr                  = "warn"
expl_impl_clone_on_copy                   = "warn"
fallible_impl_from                        = "warn"
fn_params_excessive_bools                 = "warn"
fn_to_numeric_cast_any                    = "warn"
implied_bounds_in_impls                   = "warn"
imprecise_flops                           = "warn"
inconsistent_struct_constructor           = "warn"
mixed_read_write_in_expression            = "warn"
path_buf_push_overwrite                   = "warn"
option_option                             = "warn"
or_fun_call                               = "warn"
no_mangle_with_rust_abi                   = "warn"
naive_bytecount                           = "warn"
negative_feature_names                    = "warn"
no_effect_underscore_binding              = "warn"
nonstandard_macro_braces                  = "warn"
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
