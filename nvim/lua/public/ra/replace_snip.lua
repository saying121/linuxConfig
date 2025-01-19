local M = {}
M.snippet = {
    -- ["let"] = "let ${1:var} = ${2:expr};",
    ["println!($0)"] = 'println!("$1"$2);$0',
    ["print!($0)"] = 'print!("$1"$2);$0',
    ["eprintln!($0)"] = 'eprintln!("$1"$2);$0',
    ["eprint!($0)"] = 'eprint!("$1"$2);$0',
    ["panic(${1:expr})$0"] = 'panic!("${1}"${2});$0',
    ["format(${1:args})$0"] = 'format!("${1}"${2})',
    ["format_args!($0)"] = 'format_args!("${1}"${2})',
    ["concat_idents!($0)"] = "concat_idents!(${1})",
    ["option_env!($0)"] = 'option_env!("${1}")',
    ["write!($0)"] = 'write!(${1:std::io::stdout().lock()}, "${2}")?;',
    ["writeln!($0)"] = 'writeln!(${1:std::io::stdout().lock()}, "${2}")?;',
    ["debug_assert_eq!($0)"] = "debug_assert_eq!(${1}, ${2});",
    ["debug_assert_ne!($0)"] = "debug_assert_ne!(${1}, ${2});",
    ["assert!($0)"] = "assert!(${1});",
    ["assert_eq!($0)"] = "assert_eq!(${1}, ${2});",
    -- ["unsafe"] = "unsafe {\n\t${1}\n}$0",
}

M.keyword = {
    let = true,
    enum = true,
    struct = true,
    static = true,
    const = true,
    type = true,
    mod = true,
}

return M
