#! /bin/bash

# Install multitouch gestures on Elementary OS
echo "Downloading libinput-gestures library."
cd ~/Downloads
git clone http://github.com/bulletmark/libinput-gestures
cd libinput-gestures
echo "Installing..."
sudo make install
cd ..

echo "Installing other dependencies."
sudo apt get install libinput-tools xdotool
echo "Adding current user to input group"
sudo gpasswd -a $USER input

echo "Start libinput-gestures on startup."
libinput-gestures-setup autostart
git clone https://github.com/threecgreen/dotfiles.git

echo "Creating gestures configuration file."
cp ./dotfiles/libinput-gestures.conf ~/.config/libinput-gestures.conf

echo "Finished installation and configuration. Logout and log back in for changes to take effect."
echo "It's now safe to delete the libinput-gestures and dotfiles directories in ~/Downloads"
