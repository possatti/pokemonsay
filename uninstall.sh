#!/bin/sh

#
# This script uninstall pokemonsay.
#

install_path="$HOME/.config/pokemonsay/"
bin_path="$HOME/bin/pokemonsay"

# Remove the install directory
rm -r $install_path

# Remove the bin file
rm $bin_path

# Say what's going on.
echo "'$install_path' directory was removed."
echo "'$bin_path' file was removed."
