#!/bin/bash

function digitaldatetime() {
  echo `date +"%Y%m%d%H%M%S"`
}

vim_config=`pwd -P`
cd $HOME

echo "mv .vimrc .vimrc.`digitaldatetime`"
mv .vimrc .vimrc.`digitaldatetime`2>/dev/null
echo "mv .vim .vim.`digitaldatetime`"
mv .vim .vim.`digitaldatetime`2>/dev/null

echo "ln -s ${vim_config}/_vimrc .vimrc"
ln -s ${vim_config}/_vimrc .vimrc
echo "ln -s ${vim_config}/.vim .vim"
ln -s ${vim_config}/_vim .vim
vim -c "PlugInstall|qa"

echo "enjoy!"
