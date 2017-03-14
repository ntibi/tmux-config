#!/bin/sh


REPO_BASE="$(dirname "$PWD/$0")"
REPO_TMUX="$(realpath $REPO_BASE/tmux.conf)"

DEST="$HOME/.tmux.conf"

echo "checking for updates..."
git --git-dir $REPO_BASE/.git pull

if [ ! -e $DEST ] && [ ! -L $DEST ];
then
	echo "linking $DEST with $REPO_TMUX"
	ln -s $REPO_TMUX $DEST
else
	if [ -L $DEST ];
	then
		if [ $(readlink $DEST) = $(echo $REPO_TMUX) ];
		then
			echo "new .tmux.conf already installed"
		else
			echo "removing old $DEST pointing at $(readlink $DEST)"
			unlink $DEST
			echo "linking $DEST with $REPO_TMUX"
			ln -s $REPO_TMUX $DEST
		fi
	else
		echo "linking $DEST with $REPO_TMUX"
		cat $DEST >> "$HOME/.old.tmux.conf"
		echo "old $DEST content is now in $HOME/.old.tmux.conf"
		rm $DEST
		ln -s $REPO_TMUX $DEST
	fi
fi

echo "type 'tmux source-file $DEST' to apply update"
echo "Done"
