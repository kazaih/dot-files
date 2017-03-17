echo off

set vim_plugins_path=%USERPROFILE%\.vim

set dotfiles_path=
set /P dotfiles_path="dot-files�̃p�X����͂��Ă�������: "

if NOT EXIST %dotfiles_path% (
	echo;
	echo �w�肳�ꂽdot-files�p�X�����݂��܂���
	exit /B
)

echo;
echo ���V���{���b�N�����N����
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
echo ����GVim ���N������ �h :call dein#install() �h �R�}���h�����s���Ă��������B
echo �����v���O�C���̃C���X�g�[�����I���܂����� Enter�L�[�������Ă��������B
pause

echo;
echo;
echo ��VimProc DLL �R�s�[
copy %dotfiles_path%\vimproc.lib\vimproc_win32.dll %vim_plugins_path%\dein\repos\github.com\Shougo\vimproc.vim\autoload
copy %dotfiles_path%\vimproc.lib\vimproc_win64.dll %vim_plugins_path%\dein\repos\github.com\Shougo\vimproc.vim\autoload


echo;
echo "�����ϐ��ݒ�(PATH << %USERPROFILE%\%dotfiles_path%\vim.config\ctags)"
setx /M PATH "%PATH%;%USERPROFILE%\%dotfiles_path%\vim.config\ctags"

echo;
echo ��Vim�ݒ肪�I�����܂���
