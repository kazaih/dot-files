echo off

set vim_plugins_path=%USERPROFILE%\.vim

set dotfiles_path=
set /P dotfiles_path="dot-filesのパスを入力してください: "

if NOT EXIST %dotfiles_path% (
	echo;
	echo 指定されたdot-filesパスが存在しません
	exit /B
)

echo;
echo ●シンボリックリンク生成
IF EXIST %USERPROFILE%\.vimrc            del %USERPROFILE%\.vimrc
IF EXIST %USERPROFILE%\.gvimrc           del %USERPROFILE%\.gvimrc
IF EXIST %USERPROFILE%\.dein.toml        del %USERPROFILE%\.dein.toml
IF EXIST %USERPROFILE%\.dein.lazy.toml   del %USERPROFILE%\.dein.lazy.toml
IF EXIST %USERPROFILE%\.dein.toml_win    del %USERPROFILE%\.dein.toml_win 
IF EXIST %USERPROFILE%\.dein.toml_mac    del %USERPROFILE%\.dein.toml_mac 
IF EXIST %USERPROFILE%\.dein.toml_unix   del %USERPROFILE%\.dein.toml_unix
IF EXIST %USERPROFILE%\dicts             del %USERPROFILE%\dicts
IF EXIST %USERPROFILE%\.ctags            del %USERPROFILE%\.ctags
IF EXIST %USERPROFILE%\ctags             rmdir %USERPROFILE%\ctags

mklink %USERPROFILE%\.vimrc              %dotfiles_path%\.vimrc
mklink %USERPROFILE%\.gvimrc             %dotfiles_path%\.gvimrc
mklink %USERPROFILE%\.dein.toml          %dotfiles_path%\.dein.toml
mklink %USERPROFILE%\.dein.lazy.toml     %dotfiles_path%\.dein.lazy.toml
mklink %USERPROFILE%\.dein.toml_win      %dotfiles_path%\.dein.toml_win
mklink %USERPROFILE%\.dein.toml_mac      %dotfiles_path%\.dein.toml_mac
mklink %USERPROFILE%\.dein.toml_unix     %dotfiles_path%\.dein.toml_unix
mklink %USERPROFILE%\dicts               %dotfiles_path%\dict
mklink %USERPROFILE%\.ctags              %dotfiles_path%\.ctags
mklink /d %USERPROFILE%\ctags            %dotfiles_path%\ctags

echo;
echo;
echo;
echo ★★GVim を起動して ” :call dein#install() ” コマンドを実行してください。
echo ★★プラグインのインストールが終わりましたら Enterキーを押してください。
pause

echo;
echo;
echo ●VimProc DLL コピー
copy %dotfiles_path%\vimproc.lib\vimproc_win32.dll %vim_plugins_path%\dein\repos\github.com\Shougo\vimproc.vim\autoload
copy %dotfiles_path%\vimproc.lib\vimproc_win64.dll %vim_plugins_path%\dein\repos\github.com\Shougo\vimproc.vim\autoload


echo;
echo "●環境変数設定(PATH << %USERPROFILE%\%dotfiles_path%\vim.config\ctags)"
setx /M PATH "%PATH%;%USERPROFILE%\%dotfiles_path%\vim.config\ctags"

echo;
echo ●Vim設定が終了しました
