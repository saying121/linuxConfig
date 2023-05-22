scriptencoding utf-8
let mapleader=';'
" let maplocalleader=';'

nnoremap * *N
xnoremap * *N
nnoremap # #N
xnoremap # #N

nnoremap ,, ggVG

" 多行移动
xnoremap <M-j> :m '>+1<cr>gv=gv
xnoremap <M-k> :m '<-2<cr>gv=gv

" nnoremap ` %
" xnoremap ` %
nnoremap <silent><leader>w :w<CR>
nnoremap <silent><leader>x :x<CR>

nnoremap j gj
xnoremap j gj
onoremap j gj

nnoremap k gk
xnoremap k gk
onoremap k gk

nnoremap <up> g<up>
xnoremap <up> g<up>
onoremap <up> g<up>

nnoremap <down> g<down>
xnoremap <down> g<down>
onoremap <down> g<down>

nnoremap <home> g<home>
nnoremap <end> g<end>

nnoremap $ g$
xnoremap $ g$
onoremap $ g$

nnoremap 0 g0
xnoremap 0 g0
onoremap 0 g0

nnoremap ^ g^
xnoremap ^ g^
onoremap ^ g^

set wrap

" 大写h、l移动到行首、行尾非空白符号,visual 'g_':行尾不包括换行符(包括就用$)
nnoremap L g$
xnoremap L g_
onoremap L g_

nnoremap H g^
xnoremap H g^
onoremap H g^

" 选取进行缩进后还被选中
xnoremap < <gv
xnoremap > >gv

" copy paste system clipboard
" ^= 把值加到默认值前
"*和"+有什么差别呢?
"* 是在系统剪切板中表示选择的内容
"+ 是在系统剪切板中表示选择后Ctrl+c复制的内容
set clipboard^=unnamed          " *寄存器
set clipboard^=unnamedplus          " +寄存器
nnoremap Y y$

" 创建tab
nnoremap <silent><leader>tn :tabnew<CR>
nnoremap <silent><leader>tc :tabclose<CR>
nnoremap <silent><leader>to :tabonly<CR>

" 切换buffer
nnoremap <silent>]b :bn<CR>
nnoremap <silent>[b :bp<CR>
nnoremap <silent>]B :blast<CR>
nnoremap <silent>[B :bfirst<CR>

" 切换窗口
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l

" tnoremap <Esc> <C-\><C-n>
tnoremap <M-e> <C-\><C-n>

" 调整窗口大小
nnoremap <M-,> <C-W><
nnoremap <M-.> <C-W>>
nnoremap <M--> <C-W>-
nnoremap <M-=> <C-W>+

" Alt+t开启关闭终端,vim和nvim不太一样
" nnoremap <M-t> :terminal<CR>A
" tnoremap <M-t> exit<CR>

nnoremap <silent><BackSpace> :noh<CR>
" nnoremap <space>s :source $MYVIMRC<CR>

nnoremap <silent><leader>nc :set nonumber norelativenumber signcolumn=no<CR>
nnoremap <silent><leader>yc :set number relativenumber signcolumn=yes:1<CR>

augroup FTMap
    autocmd!
    autocmd FileType qf nnoremap <buffer> q :cclose<CR>
augroup END
