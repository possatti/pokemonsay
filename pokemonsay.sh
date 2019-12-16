#!/bin/bash

usage() {
  echo "
  Description: Prints a Pokémon with a message.
  Usage:
	$(basename $0) [-p POKÉMON] [-f COWFILE] [-w COLUMN] [-lnNt] [-h] [MESSAGE]

  Options:
    -p, --pokemon POKÉMON_NAME
      CHOOSE a Pokémon by name.
    -f, --file COWFILE
      CHOOSE a Pokémon cowfile.
    -W, --word-wrap COLUMN
      Specifies roughly where the message should be wrapped.
    -n, --no-wrap
      Do not wrap the message.
    -l, --list
      List all the Pokémon available.
    -N, --no-name
      Do not print the name of the Pokémon.
    -t, --think
      Make the Pokémon think the message instead of saying it.
    -h, --help
      Display this usage message.
    MESSAGE
      The message for chosen Pokémon to say. If this is not provided the Pokémon will read from STDIN"
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
	-W|--word-wrap)
		WORD_WRAP="$2"
		shift; shift
		;;
	-W=*|--word-wrap=*)
		WORD_WRAP="${1#*=}"
		shift
		;;
	-n|--no-wrap)
		DISABLE_WRAP="YES"
		shift
		;;
	-l|--list)
		list_pokemon
		;;
	-n|--no-name)
		DISPLAY_NAME="NO"
		shift
		;;
	-t|--think)
		THINK="YES"
		shift
		;;
	-h|--help)
		usage
		;;
	-*)
		echo
		echo "  Unknown option '$1'"
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

# Disable wrapping if the option is set, otherwise
# define where to wrap the message.
if [ "${DISABLE_WRAP:-}" == "YES" ]; then
	word_wrap="-n"
elif [ -n "$WORD_WRAP" ]; then
	word_wrap="-W $WORD_WRAP"
fi

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

# Call cowsay or cowthink.
if [ -n "$THINK" ]; then
	cowthink -f "$pokemon_cow" $word_wrap $MESSAGE
else
	cowsay -f "$pokemon_cow" $word_wrap $MESSAGE
fi

# Write the pokemon name, unless requested otherwise.
if [ -z "$DISPLAY_NAME" ]; then
	echo $pokemon_name
fi
