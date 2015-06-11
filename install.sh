#!/bin/sh

# Define install directories and names
install_path="$HOME/.pokemonsay/"
bin_install_path="$HOME/bin/"

# Make sure the directories exist
mkdir -p $install_path
mkdir -p $install_path/cows/
mkdir -p $bin_install_path

# Copy the cows, the main script and the uninstall script to the
# install path.
cp ./cows/*.cow $install_path/cows/
cp ./pokemonsay.sh $install_path
cp ./uninstall.sh $install_path

# Create a main script in the home bin directory.
cat > $bin_install_path/pokemonsay <<- EOF
	#!/bin/sh

	# This script changes to the pokemonsay installation directory,
	# runs the main script for running the pokemonsay, and changes
	# back to the previous directory.

	current_path=`pwd`
	cd $install_path
	./pokemonsay.sh
	cd \$current_path
EOF

# Change permission of the main script
chmod +x $bin_install_path/pokemonsay

echo "The files were installed to '$install_path'."
echo "A 'pokemonsay' script was created in '$bin_install_path'."
echo "The uninstall script was copied to '$install_path'."
echo "It may be necessary to logout and login back again in order to have the 'pokemonsay' available in your path."
