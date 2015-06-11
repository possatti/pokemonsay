#!/bin/sh

# Define where the pokemon are.
pokemon_path=`pwd`/cows

# Find all pokemon in the pokemon path and choose a random one.
pokemon=$(find $pokemon_path -name "*.cow" | shuf -n1)

# Get the pokemon name.
filename=$(basename "$pokemon")
pokemon_name="${filename%.*}"

# Call cowsay.
cowsay -f $pokemon

# Write the pokemon name.
echo $pokemon_name
