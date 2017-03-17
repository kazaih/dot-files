"何で動いているか調べる
let s:is_windows  =  has('win16') || has('win32') || has('win64') || has('win32unix')
let s:is_mac      =  has('macunix') || has('mac')
let s:is_unix     =  has('unix')
let s:is_cygwin   =  has('win32unix')
let s:is_cui      = !has('gui_running')

" Common ---------------------------------
set nocompatible       " vim
syntax enable
colorscheme jellybeans " カラースキームの設定
set background=dark    " 背景色の傾向
syntax on
set lines=40           " 縦幅　デフォルトは24
set columns=110        " 横幅　デフォルトは80
set guioptions+=a
set whichwrap=b,s,<,>,[,]

"文字カラー設定
highlight Comment ctermfg=40 guifg=#00DD00
highlight String ctermfg=9 guifg=#EE0000
highlight LineNr ctermfg=0 ctermbg=255 guifg=#ffffff guibg=#000000
highlight Normal guifg=#ffffff guibg=#000000

" Windows 32bit(おそらくWindows7)時はMigu1Mフォントを指定
if has('win64')
elseif has('win32')
	set guifont=Migu_1M:h11
	set guifontwide=Migu_1M:h11
endif

"IMEオン時のカーソルカラー
if has('multi_byte_ime') || has('xim')
   highlight Cursor ctermfg=232 ctermbg=153 guifg=#151515 guibg=#b0d0f0  
   highlight CursorIM  ctermfg=232 ctermbg=208 guifg=#b0d0f0 guibg=#FF5F1C
endif

" タブインデントガイド
let g:indent_guides_auto_colors=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=236
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=238
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1

