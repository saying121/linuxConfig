" set nocompatible

let s:dein_base = '~/.local/share/vim/dein/'

" Set dein source path (required)
let s:dein_src = '~/.local/share/vim/dein/repos/github.com/Shougo/dein.vim'

" Set dein runtime path (required)
execute 'set runtimepath+=' . s:dein_src

" -------------------------------------------
" Call dein initialization (required)
call dein#begin(s:dein_base)

call dein#add(s:dein_src)

call dein#add('dstein64/vim-startuptime')
call dein#add('tpope/vim-surround',{
            \ 'on_map' : {'n' : ['ys','yS','ds','cs'], 'v' : ['S']}
            \ })

call dein#add('prabirshrestha/vim-lsp')
call dein#add('mattn/vim-lsp-settings')

call dein#add('prabirshrestha/asyncomplete.vim')
call dein#add('prabirshrestha/asyncomplete-lsp.vim')

call dein#add('preservim/nerdtree')

call dein#add('tribela/vim-transparent')
call dein#add('tpope/vim-commentary',{
            \ 'on_map' : {'n' : ['gc'], 'v' : ['gc']}
            \ })
call dein#add('rhysd/vim-healthcheck',{
            \ 'on_cmd' : 'CheckHealth'
            \ })
call dein#add('voidekh/kyotonight.vim')

call dein#add('wsdjeg/dein-ui.vim',{
            \ 'on_cmd' : 'DeinUpdate'
            \ })

call dein#end()
call dein#save_state()
" -------------------------------------------

nnoremap <F2> :call dein#install()<CR>
