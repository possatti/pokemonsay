#!/bin/sh

# Define install directories and names
install_path="$HOME/.pokemonsay"
bin_path="$HOME/bin"
pokemonsay_bin="pokemonsay"
pokemonthink_bin="pokemonthink"
pokedex="Poké.dex"

# Make sure the directories exist
mkdir -p $install_path/
mkdir -p $install_path/cows/
mkdir -p $bin_path/
ls -1 ./cows/ > ./$pokedex

# Copy the cows and the main script to the install path.
cp ./cows/*.cow $install_path/cows/
cp ./$pokedex $install_path/
cp ./pokemonsay.sh $install_path/
cp ./pokemonthink.sh $install_path/

# Create the pokemonsay script in the home bin directory.
cat > $bin_path/$pokemonsay_bin <<- EOF
	#!/bin/sh

	# This script changes to the pokemonsay installation directory,
	# runs the main script for running the pokemonsay, and changes
	# back to the previous directory.

	cd $install_path/
	./pokemonsay.sh \$@
	cd - >/dev/null
EOF

# Create the pokemonthink script in the home bin directory.
cat > $bin_path/$pokemonthink_bin <<- EOF
	#!/bin/sh

	# This script changes to the pokemonsay installation directory,
	# runs the main script for running the pokemonthink, and changes
	# back to the previous directory.

	cd $install_path/
	./pokemonthink.sh \$@
	cd - >/dev/null
EOF

# Create uninstall script in the install directory
cat > $install_path/uninstall.sh <<- EOF
	#!/bin/sh

	#
	# This script uninstalls pokemonsay.
	#

	# Remove the install directory
	rm -r "$install_path/"

	# Remove the bin files
	rm "$bin_path/$pokemonsay_bin"
	rm "$bin_path/$pokemonthink_bin"

	# Say what's going on.
	echo "'$install_path/' directory was removed."
	echo "'$bin_path/$pokemonsay_bin' file was removed."
	echo "'$bin_path/$pokemonthink_bin' file was removed."
EOF

# Change permission of the generated scripts
chmod +x "$bin_path/$pokemonsay_bin"
chmod +x "$bin_path/$pokemonthink_bin"
chmod +x "$install_path/uninstall.sh"

echo "The files were installed to '$install_path/'."
echo "A '$pokemonsay_bin' script was created in '$bin_path/'."
echo "A uninstall script was created in '$install_path/'."
echo "It may be necessary to logout and login back again in order to have the '$pokemonsay_bin' available in your path."
