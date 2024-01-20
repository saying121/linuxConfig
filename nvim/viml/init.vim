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
    set scrolloff=23                                               " 在光标上下展现多少行
    set signcolumn=yes
else
    set cmdheight=0
    set signcolumn=yes:1

    " " 打开二进制文件，已知nvim 打不开 pdf
    " if exists('g:did_load_filetypes')
    "     if executable('lesspipe.sh')
    "         let s:lesspipe_cmd = 'LESSQUIET=1 lesspipe.sh'
    "     elseif executable('lesspipe')
    "         let s:lesspipe_cmd = 'lesspipe'
    "     endif
    "     if exists('s:lesspipe_cmd') && executable('file')
    "         augroup lesspipe
    "             autocmd!
    "             autocmd BufReadPost *
    "                         \ if empty(&l:buftype) && !did_filetype() && !&l:binary && filereadable(bufname('%')) &&
    "                         \   system('file --mime --brief ' . fnamemodify(resolve(expand('%')), ':p:S')) !~# '^text/' |
    "                         \   silent exe '%!' . s:lesspipe_cmd . ' ' . expand('%:S') |
    "                         \   setlocal filetype=text nomodifiable readonly |
    "                         \ endif
    "         augroup END
    "     endif
    " endif
    "
    " let g:zipPlugin_ext='*.apk,*.celzip,*.crtx,*.ear,*.gcsx,*.glox,*.gqsx,*.kmz,*.oxt,*.potm,*.potx,*.ppam,*.sldx,*.thmx,*.vdw,*.war,*.wsz,*.xap,*.xlam,*.xlam,*.xltm,*.xltx,*.xpi,*.zip'
endif
