set encoding=utf-8                                             " VIM打开文件用的内部编码
scriptencoding utf-8
filetype plugin indent on
syntax off                                                     " 语法高亮，用nvim-treesitter高亮
set ttimeout ttimeoutlen=10                                    " 设置切换模式的延迟时间
set history=100
set mouse=a                                                    " 鼠标可用
set autochdir                                                  " 切换文件buffer自动切换vim/nvim所在目录
set smartcase                                                  " 搜索智能大小写

" 编码设置
set fileencodings=utf-8,gb2312,gbk,gb18030,cp936,utf-16        " 检测文件编码，将fileencoding设置为最终编码
set fileencoding=utf-8                                         " 保存时的文件编码
set termencoding=utf-8                                         " 终端输出的字符编码
set fileformat=unix                                            " 设定文件格式为unix
set fileformats=unix,dos,mac                                   " 识别文件格式

set listchars=tab:>·                                           " tab显示方式
set listchars+=trail:·                                         " 行末空格显示
set listchars+=extends:⇒                                       " 一行后面还有内容时
set listchars+=precedes:⇐                                      " 一行前面还有内容时
set listchars+=leadmultispace:│\ \ \ ,
" set listchars+=space:·
set listchars+=eol:
" set listchars+=conceal:﬒
set list

set number                                                     " 显示行号
set relativenumber                                             " 相对行号
set hlsearch                                                   " 搜索结果高亮
set incsearch                                                  " 搜索输入时动态高亮
set showmatch                                                  " 高亮显示匹配括号
set matchpairs=(:),{:},[:],':',\":\"
set matchtime=1

set foldcolumn=1                                               " 显示折叠提示

set autoindent                                                 " 和前一行缩进相同
set smartindent                                                " 和前一行有相同缩进量。识别}(不缩进)，识别c语言。#开头行不缩进。
set cindent                                                    " 用c语言缩进格式

" 统一tab为4
set shiftwidth=4                                               " >>命令缩进的空格数
set tabstop=4                                                  " TAB键宽度
set smarttab                                                   " 根据文件中其他地方的缩进空格个数来确定一个 tab 是多少个空格
set expandtab                                                  " 把TAB换成空格
set softtabstop=4                                              " 将连续数量的空格视作一个tab,可以一次删除

set updatetime=100                                             " swap时文件,防止崩溃,和CursorHole事件时间间隔，用 antoinemadec/FixCursorHold.nvim 解耦CursorHole
set directory=~/.local/share/nvim/swapFile                     " swap文件位置
set writebackup                                                " 保存成功就删除
set backup                                                     " 写入前备份文件
set backupdir=~/.local/share/nvim/backupdir                    " 设置备份文件目录

set swapfile                                                   " 创建临时交换文件
set updatecount=100                                            " 交换文件刷新方式,400字/updatetime=time

set undofile                                                   " 撤销文件
set undodir=~/.local/share/nvim/undodir                        " 指定撤销文件目录

" set scrolloff=23                                               " 在光标上下展现多少行
set sidescrolloff=20                                            " 横向展示的列

set termguicolors
set conceallevel=2

set nowrap

set fillchars=eob:\ ,fold:\ ,foldopen:,foldsep:\ ,foldclose:
set foldcolumn=1
set foldlevel=99
set foldlevelstart=99
