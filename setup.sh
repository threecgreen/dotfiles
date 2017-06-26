#! /bin/bash
# Create necessary symbolic links for dotfiles.
#
# Determine OS
case $(uname -s) in
    linux*) OS="linux";;
    darwin*) OS="mac";;
    mysys*) OS="windows";;
    solaris*) OS="solaris";;
    bsd*) OS="bsd";;
    *) echo "Unknown OS"
        exit 1;;
esac

# Linking bashrc/bash_profile
# Linux distros
echo "Linking bash configuration."
if [[ "$OS" == "linux" ]]; then
    ln -sv ./.bashrc ~/.bashrc
    ln -sv ./.bash_aliases ~/.bash_aliases
# macOS / OSX
elif [[ "$OS" == "mac" ]]; then
    ln -sv ./.bash_profile ~/.bash_profile
    ln -sv ./.bash_aliases ~/.bash_aliases
else
    echo "Unknown operating system; bash configuration file skipped."
fi

echo "Linking vim/neovim configuration."
if [[ -f /usr/local/bin/nvim ]];
    ln -sv ./.vimrc  ~/.config/nvim/init.vim
else
    echo "Do you wish to install neovim (y/n): "
    select yn in "Yes" "No"; do
        case $yn in
            # TODO: Install neovim via script
            [Yy]* ) break;;
            [Nn]* ) break;;
            * ) echo "Please answer yes or no";;
        esac
    done
fi
ln -sv ./.vimrc ~/.vimrc

# Linking VSCode configuration
# Linux distros
echo "Linking VSCode configuration."
if [[ "$OS" == "linux" ]]; then
    # TODO: Add check for vscode install location on Linux
    ln -sv ./vscode-settings.json ~/.config/Code/User/settings.json
# macOS / OSX
elif [[ "$OS" == "mac" ]]
    && [[ -f "/Applications/Visual Studio Code.app"]]; then
    ln -sv ./vscode-settings.json "~/Library/Application Support/Code/User/settings.json"
fi

# Git configuration
# TODO: Add ability to install git if not already installed.
echo "Linking git configurations."
ln -sv ./.git ~/.git
ln -sv ./.gitconfig ~/.gitconfig

# Tmux configuration
# TODO: Add ability to install tmux if not already installed.
echo "Linking tmux configurations and plugins."
ln -sv ./.tmux ~/.tmux
ln -sv ./.tmux.config ~/.tmux.config
