#!/bin/bash

echo "Moving files to their location..."

if [ ! -d $HOME/Documents/iTerm2 ]; then
  mkdir $HOME/Documents/iTerm2
fi

cp -f $PWD/com.googlecode.iterm2.plist $HOME/Documents/iTerm2/

if [ -f $HOME/.antigenrc ]; then
  rm -rf $HOME/.antigenrc
fi

ln -sf $PWD/.antigenrc $HOME/.antigenrc

if [ -f $HOME/.gitconfig ]; then
  rm -rf $HOME/.gitconfig
fi

ln -sf $PWD/.gitconfig $HOME/.gitconfig

if [ -f $HOME/.tmux.conf ]; then
  rm -rf $HOME/.tmux.conf
fi

ln -sf $PWD/.tmux.conf $HOME/.tmux.conf

if [ -f $HOME/.zshrc ]; then
  rm -rf $HOME/.zshrc
fi

ln -sf $PWD/.zshrc $HOME/.zshrc

if [ -f $HOME/alias.zsh ]; then
  rm -rf $HOME/alias.zsh
fi

ln -sf $PWD/alias.zsh $HOME/alias.zsh

rm -rf $HOME/.antigen/bundles/denysdovhan/spaceship-prompt/sections/char.zsh

ln -sf $PWD/char.zsh $HOME/.antigen/bundles/denysdovhan/spaceship-prompt/sections/char.zsh

if [ ! -d $HOME/.config/nvim ]; then
  mkdir $HOME/.config/nvim
fi

ln -sf $PWD/nvim/init.vim $HOME/.config/nvim/init.vim
ln -sf $PWD/nvim/plugins.vim $HOME/.config/nvim/plugins.vim
ln -sf $PWD/nvim/coc-settings.json $HOME/.config/nvim/coc-settings.json

if [ ! -d $HOME/.config/nvim/snippets ]; then
  mkdir $HOME/.config/nvim/snippets
fi

for file in $PWD/nvim/snippets/*; do
  ln -sf $file $HOME/.config/nvim/snippets
done

if [ ! -d $HOME/.tmux ]; then
  mkdir $HOME/.tmux
fi

ln -sf $PWD/tpm/.git_status.sh $HOME/.tmux/.git_status.sh

echo "DONE..."
exit 0
