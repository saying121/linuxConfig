# Neovim 配置简述

<!--toc:start-->

- [Neovim 配置简述](#neovim-配置简述)
  - [一些小细节](#一些小细节)
    - [关于 Cargo.toml](#关于-cargotoml)
  - [推荐几个教程](#推荐几个教程)
  - [版本要求](#版本要求)
    - [主要插件](#主要插件)
    - [ui](#ui)
  - [单使用 neovim 配置](#单使用-neovim-配置)
  - [一些已知问题](#一些已知问题)
  <!--toc:end-->

![dashboard picture](./pictures/dashboard.png)
依赖在 `../install.sh` 的必装部分，此目录下 `./install.sh` 会安装主要的依赖项。

插件配置在 `nvim/lua/plugins` 目录下，使用[lazy](https://github.com/folke/lazy.nvim)插件管理器安装。

- `./coc-config` : [coc](https://github.com/neoclide/coc.nvim) 未使用，但保留其配置。
- `./colors` : 配置 neovim 透明，用 `colorscheme` 使用，例如在配置[tokyonight](https://github.com/folke/tokyonight.nvim)后加载，使得背景透明。
- `./dashboard` : 是[dashboard.nvim](https://github.com/glepnir/dashboard-nvim)的 `preview file`。
- `./ftplugin` : neovim 会根据文件类型加载其中文件， `文件类型` + `.lua/vim` 后缀，会先加载 `.vim` ，后加载 `.lua` 。
- `./lua/dap-conf` : 是对各个语言 `Debug Adapter` 的配置。
- `./lua/lsp` : 是对各个 `lsp` 的 `setting` 部分的配置，返回一个 `setting` 部分的 `table` ，nvim-lspconfig 会加载其中 `.lua` 后缀的文件。
- `./lua/plugins` : 是对各个插件的配置。
- `./plugin` : nvim 会自动加载其中 `.vim/lua` 文件。
- `./vim-config` : 对 **vim** 相关的配置。
- `./viml` : **vim** 和 **neovim** 的共用配置。
- `./cheatsheets.txt` :[vim 操作速查](https://github.com/skywind3000/awesome-cheatsheets/blob/master/editors/vim.txt)。
- `./tasks` : 各种语言的编译方式,有些效果在 nvim 的终端不起作用，使用正常终端(tmux 也可以)来运行查看效果,例如闪烁文本

## 一些小细节

终端里面 **Ctrl+I** 和 **Tab** 是一样的，它们都发送 ASCII 9（水平制表符）字符，**Insert** 模式映射要小心

尽量用 `xnoremap` 而不是 `vnoremap`，`:h map` 。

```vimdoc
         Mode  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang | ~
Command        +------+-----+-----+-----+-----+-----+------+------+ ~
[nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
[nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |
```

```bash
# platformio 生成 compile_commands.json
pio run -t compiledb
```

### 关于 Cargo.toml

- 把 `Cargo.toml` 改成 `toml_rs` 文件类型
- treesitter里面把 `toml` 高亮应用于 `toml_rs`
- 设置 `taplo` 在 `toml_rs` 文件类型启动

就能只给 `Cargo.toml` 添加一些 snippet 。

## 推荐几个教程

- [vim 基础教程](https://www.imooc.com/learn/1129)
- [Vim 从入门到精通](https://github.com/wsdjeg/vim-galore-zh_cn)
- [在 neovim 中使用 lua](https://github.com/glepnir/nvim-lua-guide-zh)
- [中文速查表](https://github.com/skywind3000/awesome-cheatsheets)
- [菜鸟教程 lua](https://www.runoob.com/lua/lua-tutorial.html)

## 版本要求

最低 0.10.0 ，[dyninput.nvim](https://github.com/nvimdev/dyninput.nvim) ，
内置的 inlay hints 只能在 >=0.10.0 版本才能用

### 主要插件

- [asynctasks.vim](https://github.com/skywind3000/asynctasks.vim) 一键运行代码
- [crates.nvim](https://github.com/saecki/crates.nvim) 获取 rust crate 补全信息
- [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) 专门为 rust 开发的插件
- [lazy.nvim](https://github.com/folke/lazy.nvim) 插件管理器
- [lspsaga.nvim](https://github.com/glepnir/lspsaga.nvim) 更好的 lsp ui
- [mason.nvim](https://github.com/williamboman/mason.nvim) 安装 lsp， linter， adapter， formatter 等等
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) 自动补全
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) 配置 lsp
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) 语法高亮
- [stay-centered.nvim](https://github.com/arnamak/stay-centered.nvim) 保持光标所在行在屏幕中间，进行配置可以获得更好的鼠标滚动体验，自己去配置里面看
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) 模糊查找插件
- [vim-dadbod](https://github.com/tpope/vim-dadbod) 连接数据库插件
- [nvim-lsp-file-operations](https://github.com/antosha417/nvim-lsp-file-operations) 根据文件名重命名模块
  [oil.nvim](https://github.com/stevearc/oil.nvim) 也有这个功能

### ui

- [dressing.nvim](https://github.com/stevearc/dressing.nvim) 更好的选择框 ui
- [mini.indentscope](https://github.com/echasnovski/mini.indentscope) 缩进线
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) 主题

## 单使用 neovim 配置

```bash
mkdir ~/.linuxConfig

cd ~/.linuxConfig

git init

git remote add -f origin https://github.com/saying121/linuxConfig.git

git config core.sparsecheckout true

echo "nvim" >>.git/info/sparse-checkout

git checkout main

# thenvim 自己取名
ln -s ~/.linuxConfig/nvim ~/.config/thenvim

# 自行选择
./install.sh

# thenvim，nvimboot 自己取名，shellrc自己看着改
echo 'alias nvimboot="NVIM_APPNAME=thenvim nvim"' >> ~/.zshrc

# 启动
thenvim

# 升级
git pull
```

## 一些已知问题

`./viml/init.vim` 有一段打开二进制文件的自动命令，有可能导致一些文本文件打不开，自行注释。或者在 `./lua/init.lua` 中添加文件类型。
