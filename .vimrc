filetype off
syntax enable
filetype indent on
filetype plugin on

"何で動いているか調べる
let s:is_windows  =  has('win16') || has('win32') || has('win64') || has('win32unix')
let s:is_mac      =  has('macunix') || has('mac')
let s:is_unix     =  has('unix')
let s:is_cygwin   =  has('win32unix') || has('win64unix')
let s:is_cui      = !has('gui_running')

let s:use_dein = 1

" vi compatibility
if !&compatible
  set nocompatible
endif

" .vim dir生成
let s:vimdir = $HOME . "/.vim"
if has("vim_starting")
  if ! isdirectory(s:vimdir)
    call system("mkdir " . s:vimdir)
  endif
endif

"----------------------------------------------------------------------------
" プラグイン管理（dein）の設定
"----------------------------------------------------------------------------
let s:dein_enabled  = 0
if s:use_dein && v:version >= 704
	let s:dein_enabled = 1

	" deinの自動インストール
	let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
	let s:dein_dir = s:vimdir . '/dein'
	let s:dein_github = s:dein_dir . '/repos/github.com'
	let s:dein_repo_name = "Shougo/dein.vim"
	let s:dein_repo_dir = s:dein_github . '/' . s:dein_repo_name
	if !isdirectory(s:dein_repo_dir)
		echo "dein is not installed, install now "
		let s:dein_repo = "https://github.com/" . s:dein_repo_name
		echo "git clone " . s:dein_repo . " " . s:dein_repo_dir
		call system("git clone " . s:dein_repo . " " . s:dein_repo_dir)
	endif
	let &runtimepath = &runtimepath . "," . s:dein_repo_dir

	" プラグイン読み込み＆キャッシュ作成
	let s:toml           = '~/.dein.toml'
	let s:lazy_toml      = '~/.dein.lazy.toml'
	let s:toml_win       = '~/.dein.toml_win'
	let s:toml_mac       = '~/.dein.toml_mac'
	let s:toml_unix      = '~/.dein.toml_unix'
	let s:vim_scp_upload = '~/.vim-scp-upload.conf'
	if dein#load_state(s:dein_dir)
		call dein#begin(s:dein_dir)
		call dein#load_toml(s:toml, {'lazy': 0})
		call dein#load_toml(s:lazy_toml, {'lazy': 1})
		if s:is_windows
			" Windows専用プラグイン設定
			call dein#load_toml(s:toml_win, {'lazy': 0})
		elseif s:is_mac
			" mac専用プラグイン設定
			call dein#load_toml(s:toml_mac, {'lazy': 0})
		elseif s:is_unix
			" Unix(Linux)専用プラグイン設定
			call dein#load_toml(s:toml_unix, {'lazy': 0})
		endif
		call dein#end()
		call dein#save_state()
	endif
	" vim-scp-uploadサーバー情報
	if filereadable(expand(s:vim_scp_upload))
		source ~/.vim-scp-upload.conf
	endif

	" インストールプラグイン check.
	if dein#check_install()
		call dein#install()
	endif
endif

"----------------------------------------------------------------------------
" 基本設定
"----------------------------------------------------------------------------
"エンコーディング設定
if s:is_mac 
	set encoding=utf8 
endif
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'eucjp-ms'
		let s:enc_jis = 'iso-2022-jp-3'
	elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	if &encoding ==# 'utf-8'
		let s:fileencodings_default = &fileencodings
		let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
		let &fileencodings = &fileencodings .','. s:fileencodings_default
		unlet s:fileencodings_default
	else
		let &fileencodings = &fileencodings .','. s:enc_jis
		set fileencodings+=utf-8,ucs-2le,ucs-2
		if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			set fileencodings+=cp932
			set fileencodings-=euc-jp
			set fileencodings-=euc-jisx0213
			set fileencodings-=eucjp-ms
			let &encoding = s:enc_euc
			let &fileencoding = s:enc_euc
		else
			let &fileencodings = &fileencodings .','. s:enc_euc
		endif
	endif
	unlet s:enc_euc
	unlet s:enc_jis
	endif
	if has('autocmd')
		function! AU_ReCheck_FENC()
			if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif
"vim各種パラメータ設定
set fileformats=unix,dos,mac       "改行自動判別
set nobackup                       "バックアップファイルのディレクトリを指定する
set noswapfile                     "スワップファイル用のディレクトリを指定する
set hidden                         "複数ファイルの編集を可能にする
set autoread                       "内容が更新されたら自動的に再読み込み
set clipboard+=unnamed,autoselect  "クリップボードOSと連携する
set backspace=indent,eol,start     "バックスペースでインデントや改行を削除できるようにする
set wildmenu
set cursorline                     "カーソルラインを表示する
" set cursorcolumn                 "カーソルカラムを表示する
set number                         "行番号の表示
set mouse=a                        "マウスON
set ttymouse=xterm2
set scrolloff=5                    "スクロールし始める行数
set vb t_vb=                       "ビープ音使用しない
set whichwrap=b,s,h,l,<,>,[,],~    "特定のキーに行頭および行末の回りこみ移動を許可する設定
set nowrap                         "行のおりかえし
set showcmd                        " タイプ途中のコマンドを画面最下行に表示
"set imdisable                     " ビジュアルモード切り替え時にIMEをOFF
set textwidth=0                    "自動改行を停止
set tags=./*/tags;                 "ctagsの範囲をカレントディレクトに親まで対象とする

" WindowsでCtrl-C,Ctrl-Vを利用できるようにする
" source $VIMRUNTIME/mswin.vim

"----------------------------------------------------------------------------
"カラー設定
"----------------------------------------------------------------------------
" ターミナルタイプによるカラー設定
"if s:is_cygwin
  ""cygwin-minttyではこれがないとsolarized反映しない…
  "let g:solarized_termcolors=256
  "if &term =~# '^xterm' && &t_Co < 256
    "set t_Co=256  " Extend terminal color of xterm
  "endif
"endif

"カラースキーム
syntax on
set background=dark
colorscheme jellybeans
set t_Co=256

"画面カラー設定
highlight Comment ctermfg=40 guifg=#00DD00 
highlight String ctermfg=9 guifg=#EE0000 
highlight LineNr ctermfg=0 ctermbg=255 guifg=#ffffff guibg=#000000
highlight Normal guifg=#ffffff guibg=#000000

"IMEオン時のカーソルカラー
if has('multi_byte_ime')
   highlight Cursor ctermfg=232 ctermbg=153 guifg=#151515 guibg=#b0d0f0
   highlight CursorIM  ctermfg=232 ctermbg=208 guifg=#b0d0f0 guibg=#FF5F1C
endif

"----------------------------------------------------------------------------
"ターミナル設定
"----------------------------------------------------------------------------
if s:is_cui
  if &term !=# 'cygwin'  " not in command prompt
    " Change cursor shape depending on mode
    let &t_ti .= "\e[1 q"
    let &t_SI .= "\e[5 q"
    let &t_EI .= "\e[1 q"
    let &t_te .= "\e[0 q"
  endif
endif

"----------------------------------------------------------------------------
"検索
"----------------------------------------------------------------------------
"set noignorecase                "検索時　大文字小文字を区別する
"set smartcase                   "大文字で検索されたら対象を大文字限定にする
set incsearch                   "インクリメンタルサーチを有効にする
set hlsearch                    "強調表示

"----------------------------------------------------------------------------
"フォーマット設定
"----------------------------------------------------------------------------
set autoindent                  "自動的にインデントする
set smartindent
set showmatch                   "閉括弧が入力された時、対応する括弧を強調する
"set smarttab                    "行頭の余白内でTabを打ち込むと'shiftwidth'の数だけインデントする
"set expandtab                   "タブ設定
set tabstop=3
"set softtabstop=2
set shiftwidth=3
set cino=:0                     "switch caseを同じ列にする
set list                        "Tab、行末の半角スペースを明示的に表示する
set listchars=tab:^\ ,trail:~

"-------------------------------------------------------------------------------
"ステータスライン
"-------------------------------------------------------------------------------
set laststatus=2                "ステータスラインを常に表示

"-------------------------------------------------------------------------------
"タブライン
"-------------------------------------------------------------------------------
set showtabline=2 " 常にタブラインを表示"
" 下記設定はGUIタブを利用できないため、表示上いまいちなので没
" function! s:SID_PREFIX()
  " return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
" endfunction

" function! s:my_tabline()
  " let s = ''
  " for i in range(1, tabpagenr('$'))
    " let bufnrs = tabpagebuflist(i)
    " let bufnr = bufnrs[tabpagewinnr(i) - 1]
    " let no = i.
    " let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    " let title = fnamemodify(bufname(bufnr), ':t')
    " let title = '[' . title . ']'
    " let s .= '%'.i.'T'
    " let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    " let s .= no . ':' . title
    " let s .= mod
    " let s .= '%#TabLineFill# '
  " endfor
  " let s .= '%#TabLineFill#%T%=%#TabLine#'
  " return s
" endfunction
" let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
" set guioptions-=e

"-------------------------------------------------------------------------------
" Mapping
"-------------------------------------------------------------------------------
" コマンド       ノーマルモード 挿入モード コマンドラインモード ビジュアルモード
" map/noremap           @            -              -                  @
" nmap/nnoremap         @            -              -                  -
" imap/inoremap         -            @              -                  -
" cmap/cnoremap         -            -              @                  -
" vmap/vnoremap         -            -              -                  @
" map!/noremap!         -            @              @                  -
"-------------------------------------------------------------------------------
"タブ移動を早くする
map t1 1gt
map t2 2gt
map t3 3gt
map t4 4gt
map t5 5gt
map t6 6gt
map t7 7gt
map t8 8gt
map t9 9gt
map t0 10gt

map to :tabo
nmap <silent> <Tab> :tabnext<CR>
nmap <silent> <S-Tab> :tabprevious<CR>

"分割ウィンドウ移動を早くする
nmap <silent> <C-Tab> <C-w>w

"単語の上書きペースト
"nnoremap <silent> rp ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>

"コピーした文字で繰り返し上書きペーストする
vnoremap <silent> 0p "0p<CR>

" 検索語に中央に移動
map n nzz
map N Nzz
map * *zz
map # #zz

"行の折り返しをしているとき、見た目の次の行へ移動する
nnoremap j gj
nnoremap k gk

" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" visual モードで連続して、インデント出来るように設定
vnoremap <silent> > >gv
vnoremap <silent> < <gv

" ctagsキーマッピング
nnoremap <C-h> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <C-k> :split<CR> :exe("tjump ".expand('<cword>'))<CR>

" タグバーキーマッピング
nmap <F8> :TagbarToggle<CR>

" 高速外部Grep（The Platinum Searcher）
nnoremap <silent> ,g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
if executable('pt')
	let g:unite_source_grep_command = 'pt'
	let g:unite_source_grep_default_opts = '--nogroup --nocolor'
	let g:unite_source_grep_recursive_opt = ''
	" 大文字小文字を区別しない
	let g:unite_enable_ignore_case = 1
	let g:unite_enable_smart_case = 1
endif

