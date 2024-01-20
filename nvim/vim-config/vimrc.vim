scriptencoding utf-8

colorscheme elflord

" plugins
source ~/.config/nvim/vim-config/vim-plug.vim
" source ~/.config/nvim/vim-config/dein.vim

source ~/.config/nvim/vim-config/vim-lsp/init.vim
" source ~/.config/nvim/coc-config/init.vim
source ~/.config/nvim/vim-config/nerdtree.vim

source ~/.config/nvim/vim-config/kyotonight.vim
source ~/.config/nvim/vim-config/wilder.vim
syntax on

set undofile
set undodir=~/.local/share/vim/undodir     " 指定撤销文件目录

let g:lsp_inlay_hints_enable = 1

"Mode Settings

let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)

"Cursor settings:

"  1 -> blinking block
"  2 -> solid block
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar


"let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"let &t_SR = "\<Esc>]50;CursorShape=2\x7"
"let &t_EI = "\<Esc>]50;CursorShape=0\x7"
