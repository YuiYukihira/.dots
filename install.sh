#!/usr/bin/env bash

dotfiles_repo="git@github.com:YuiYukihira/.dots.git"
dotfiles_loc=~/.dots

install_trizen()
{
    echo "Trizen is not installed I require it to install. Do you want it to be removed after install? (y/n)"
    read remove_trizen
    git clone https://aur.archlinux.org/trizen-git.git ~/trizen
    makepkg -si ~/trizen/
}

install_dotfiles()
{
    # Check dotfiles have been installed
    if [ -d $dotfiles_loc/.git/ ]; then
        work_dir=$PWD
        cd $dotfiles_loc
        if [ "$(git config --get remote.origin.url)" = "$dotfiles_repo"]; then
            echo "Dots installing from git repo, skipping download"
        else
            cd $work_dir
            echo "Dots not installed from git repo. Downloading now."
            echo "Dotfiles will be installed in $dotfiles_loc is this ok? (y/n)"
            read check_overwrite
            if [ "$check_overwrite" = "n" ]; then
                echo "Ok, exiting installer."
                exit 1
            else
                echo "Removing old $dotfiles_loc"
                rm -rf $dotfiles_loc
                git clone $dotfiles_repo $dotfiles_loc
            fi
        fi
    else
        cd $work_dir
        echo "Dots not installed from git repo. Downloading now."
        echo "Dotfiles will be installed in $dotfiles_loc is this ok? (y/n)"
        read check_overwrite
        if [ "$check_overwrite" = "n" ]; then
            echo "Ok, exiting installer."
            exit 1
        else
            echo "Removing old $dotfiles_loc"
            rm -rf $dotfiles_loc
            git clone $dotfiles_repo $dotfiles_loc
        fi
    fi
}

sudo pacman -Syy
sudo pacman -S git
if ! [ -x "$(command -v trizen)" ]; then
    install_trizen
fi
install_dotfiles
trizen -Syy
trizen -S lightdm-webkit-theme-aether
