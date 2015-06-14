#!/bin/sh

usage() {
	echo
	echo "  Description: Pokemonsay makes a pokémon say something to you."
	echo
	echo "  Usage: $(basename $0) [-p POKEMON_NAME] [-f COW_FILE] [-l] [-n] [-h] [MESSAGE]"
	echo
	echo "  Options:"
	echo "    -p, --pokemon POKEMON_NAME"
	echo "      Choose what pokemon will be used by its name."
	echo "    -f, --file COW_FILE"
	echo "      Specify which .cow file should be used."
	echo "    -l, --list"
	echo "      List all the pokémon available."
	echo "    -n, --no-name"
	echo "      Do not tell the pokémon name."
	echo "    -h, --help"
	echo "      Display this usage message."
	echo "    MESSAGE"
	echo "      What the pokemon will say. If you don't provide a message, a message will be read form standard input."
	exit 0
}

# Where the pokemon are.
pokemon_path=`pwd`/cows

list_pokemon() {
	echo "Pokémon available in '$pokemon_path/':"
	echo
	all_pokemon="$(find $pokemon_path -name "*.cow" | sort)"
	echo "$all_pokemon" | while read pokemon; do
		pokemon=${pokemon##*/}
		pokemon=${pokemon%.cow}
		echo $pokemon
	done
	exit 0
}

# While there are arguments, keep reading them.
while [ $# -gt 0 ]
do
key="$1"
case $key in
	-p|--pokemon)
		POKEMON_NAME="$2"
		shift; shift
		;;
	-p=*|--pokemon=*)
		POKEMON_NAME="${1#*=}"
		shift
		;;
	-f|--file)
		COW_FILE="$2"
		shift; shift
		;;
	-f=*|--file=*)
		COW_FILE="${1#*=}"
		shift
		;;
	-l|--list)
		list_pokemon
		;;
	-n|--no-name)
		DISPLAY_NAME="NO"
		shift
		;;
	-h|--help)
		usage
		;;
	*)
		# Append this word to the message.
		if [ -n "$MESSAGE" ]; then
			MESSAGE="$MESSAGE $1"
		else
			MESSAGE="$1"
		fi
		shift
		;;
esac
done

# Define which pokemon should be displayed.
if [ -n "$POKEMON_NAME" ]; then
	pokemon_cow=$(find $pokemon_path -name "$POKEMON_NAME.cow")
elif [ -n "$COW_FILE" ]; then
	pokemon_cow="$COW_FILE"
else
	pokemon_cow=$(find $pokemon_path -name "*.cow" | shuf -n1)
fi

# Get the pokemon name.
filename=$(basename "$pokemon_cow")
pokemon_name="${filename%.*}"

# Call cowsay.
cowsay -f "$pokemon_cow" "$MESSAGE"

# Write the pokemon name, unless requested otherwise.
if [ -z "$DISPLAY_NAME" ]; then
	echo $pokemon_name
fi
