scriptencoding utf-8
let mapleader=';'

nnoremap * *N
vnoremap * *N
nnoremap # #n
vnoremap # #n
nnoremap ,, ggVG

" 多行移动
vnoremap <A-j> :m '>+1<cr>gv=gv
vnoremap <A-k> :m '<-2<cr>gv=gv

" 映射按键
nnoremap <silent><space>cc :cclose<CR>
nnoremap ` %
vnoremap ` %
nnoremap <silent><leader>w :w<CR>
nnoremap <silent><leader>x :x<CR>

nnoremap j gj
vnoremap j gj

nnoremap k gk
vnoremap k gk

nnoremap $ g$
nnoremap 0 g0

set wrap

" 大写h、l移动到行首、行尾非空白符号,visual 'g_':行尾不包括换行符(包括就用$)
nnoremap L g$
vnoremap L g_
nnoremap H g^
vnoremap H g^

" 选取进行缩进后还被选中
vnoremap < <gv
vnoremap > >gv

" copy paste system clipboard
" ^= 把值加到默认值前
"*和"+有什么差别呢?
"* 是在系统剪切板中表示选择的内容
"+ 是在系统剪切板中表示选择后Ctrl+c复制的内容
set clipboard^=unnamed          " *寄存器
set clipboard^=unnamedplus          " +寄存器
nnoremap Y  y$

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
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" tnoremap <Esc> <C-\><C-n>
tnoremap <c-e> <C-\><C-n>

" 调整窗口大小
nnoremap <M-,> <C-W><
nnoremap <M-.> <C-W>>
nnoremap <M--> <C-W>-
nnoremap <M-=> <C-W>+

" Alt+t开启关闭终端,vim和nvim不太一样
nnoremap <M-t> :terminal<CR>A
tnoremap <M-t> exit<CR>

nnoremap <silent><BackSpace> :noh<CR>
" nnoremap <space>s :source $MYVIMRC<CR>
