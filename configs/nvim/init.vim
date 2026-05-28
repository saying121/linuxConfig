scriptencoding utf-8

augroup LargeFile
    let g:large_file = 10485760 " 10MB

    " Set options:
    "   eventignore+=FileType (no syntax highlighting etc
    "   assumes FileType always on)
    "   noswapfile (save copy of file)
    "   bufhidden=unload (save memory when other file is viewed)
    "   buftype=nowritefile (is read-only)
    "   undolevels=-1 (no undo possible)
    au BufReadPre *
                \ let f=expand("<afile>") |
                \ if getfsize(f) > g:large_file |
                \ set eventignore+=FileType |
                \ setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 |
                \ else |
                \ set eventignore-=FileType |
                \ endif
augroup END

" 基础配置
source $HOME/.config/nvim/viml/init.vim

" 加载插件
lua require('init')
