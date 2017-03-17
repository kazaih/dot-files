# MacOS Installer

#Input dot-files git directory
echo -n " => dot-filesのパスを入力してください: (ex. /User/hogehoge/.git) > "
read gitdir

if [ ! -e $gitdir ]; then
	echo 指定されたdot-filesパスが存在しません
	exit 1
fi
	# install homebrew
if ! command -v "brew" > /dev/null; then
	echo " => start brew install ... "
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	echo " => finish brew installed "
fi

# install ctags
if ! command -v "/usr/local/bin/ctags" > /dev/null; then
	echo " => start ctags install ... "
	brew install ctags
	echo " => finish ctags installed "
fi

# install The Platinum Searcher
if ! command -v "pt" > /dev/null; then
	echo " => start The Platinum Searcher install ... "
	brew tap monochromegane/pt
	brew tap-pin monochromegane/pt
	brew install pt
	echo " => finish The Platinum Searcher installed "
fi

# Symbolic link setting
echo " => start Symbolic link setting ... "
if [ -e ~/.vimrc -o -L ~/.vimrc ]; then
	rm ~/.vimrc
fi
sudo ln -s $gitdir/.vimrc ~/.vimrc

if [ -e .gvimrc -o -L .gvimrc ]; then
	rm ~/.gvimrc
fi
sudo ln -s $gitdir/.gvimrc ~/.gvimrc

if [ -e .dein.toml -o -L .dein.toml ]; then
	rm ~/.dein.toml
fi
sudo ln -s $gitdir/.dein.toml ~/.dein.toml

if [ -e .dein.lazy.toml -o -L .dein.lazy.toml ]; then
	rm ~/.dein.lazy.toml
fi
sudo ln -s $gitdir/.dein.lazy.toml ~/.dein.lazy.toml

if [ -e .dein.toml_win -o -L .dein.toml_win ]; then
	rm ~/.dein.toml_win
fi
sudo ln -s $gitdir/.dein.toml_win ~/.dein.toml_win

if [ -e .dein.toml_mac -o -L .dein.toml_mac ]; then
	rm ~/.dein.toml_mac
fi
sudo ln -s $gitdir/.dein.toml_mac ~/.dein.toml_mac

if [ -e .dein.toml_unix -o -L .dein.toml_unix ]; then
	rm ~/.dein.toml_unix
fi
sudo ln -s $gitdir/.dein.toml_unix ~/.dein.toml_unix

if [ -e .ctags -o -L .ctags ]; then
	rm ~/.ctags
fi
sudo ln -s $gitdir/.ctags ~/.ctags

echo " => finish Symbolic link "

# make vimproc library
if [ ! -f ~/.vim/dein/repos/github.com/Shougo/vimproc.vim/autoload/vimproc_mac.so ]; then
	if [ ! -e ~/.vim/dein/.cache/.vimrc/.dein/make_mac.mak ]; then
		echo " => !!! GVim を起動して ” :call dein#install() ” コマンドを実行してください。 "
		read -p " プラグインのインストールが終わりましたら Enterキーを押してください。 "
		echo " => start make vimproc library ... "
		cd ~/.vim/dein/.cache/.vimrc/.dein/
		make -f make_mac.mak 
		cp ~/.vim/dein/.cache/.vimrc/.dein/lib/vimproc_mac.so ~/.vim/dein/repos/github.com/Shougo/vimproc.vim/autoload
		echo " => finish make vimproc library "
	fi
fi

echo " => finish install "

