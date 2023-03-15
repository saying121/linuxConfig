scriptencoding utf-8
" 基本设置
source ~/.config/nvim/viml/base.vim

source ~/.config/nvim/viml/keymaps.vim

source ~/.config/nvim/viml/functions.vim

source ~/.config/nvim/viml/autocmds.vim


" ----------------------

if exists('g:neovide')
    source ~/.config/nvim/viml/neovide.vim
endif

" ----------------------

if !has('nvim')
    source ~/.config/nvim/vim-config/vimrc.vim
    source ~/.config/nvim/viml/statusline-config.vim
    set scrolloff=99                                               " 在光标上下展现多少行
endif
