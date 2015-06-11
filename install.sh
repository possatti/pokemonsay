#!/bin/sh

# Define install directories and names
install_path="$HOME/.pokemonsay"
bin_path="$HOME/bin"
bin_name="pokemonsay"

# Make sure the directories exist
mkdir -p $install_path/
mkdir -p $install_path/cows/
mkdir -p $bin_path/

# Copy the cows and the main script to the install path.
cp ./cows/*.cow $install_path/cows/
cp ./pokemonsay.sh $install_path/

# Create a bin script in the home bin directory.
cat > $bin_path/$bin_name <<- EOF
	#!/bin/sh

	# This script changes to the pokemonsay installation directory,
	# runs the main script for running the pokemonsay, and changes
	# back to the previous directory.

	current_path=`pwd`
	cd $install_path/
	./pokemonsay.sh
	cd \$current_path
EOF

# Create uninstall script in the install directory
cat > $install_path/uninstall.sh <<- EOF
	#!/bin/sh

	#
	# This script uninstalls pokemonsay.
	#

	# Remove the install directory
	rm -r "$install_path/"

	# Remove the bin file
	rm "$bin_path/$bin_name"

	# Say what's going on.
	echo "'$install_path/' directory was removed."
	echo "'$bin_path/$bin_name' file was removed."
EOF

# Change permission of the generated scripts
chmod +x $bin_path/$bin_name
chmod +x $install_path/uninstall.sh

echo "The files were installed to '$install_path/'."
echo "A '$bin_name' script was created in '$bin_path/'."
echo "A uninstall script was created in '$install_path/'."
echo "It may be necessary to logout and login back again in order to have the '$bin_name' available in your path."
