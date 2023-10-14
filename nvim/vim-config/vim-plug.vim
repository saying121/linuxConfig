scriptencoding utf-8

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" Plug 'francoiscabrol/ranger.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Plug 'prabirshrestha/vim-lsp'
" Plug 'mattn/vim-lsp-settings'
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'preservim/nerdtree'

Plug 'tribela/vim-transparent'
Plug 'tpope/vim-commentary'
Plug 'rhysd/vim-healthcheck'
Plug 'voidekh/kyotonight.vim'

Plug 'gelguy/wilder.nvim'

" To use Python remote plugin features in Vim, can be skipped
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

Plug 'rust-lang/rust.vim'
call plug#end()

