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
    message
      The message for chosen Pokémon to say. If this is not provided the Pokémon will read from STDIN"
    exit 0
}

# Where the pokemon are.
pokemon_path=$PWD/cows

list_pokemon() {
	echo "Pokémon available in '$POKEMON/':"
	cat ./Poké.dex
	exit 0
}

while getopts ":p:f:wnNlh" Option ; do
  case $Option in
    f ) cowfile="$OPTARG" ;;
    p ) pokemon="$POKEMON/$OPTARG" ;;
    w ) WORD_WRAP="$OPTARG" ;;
    n ) DISABLE_WRAP=true   ;;
    N ) DISABLE_NAME=true   ;;
    l ) list_pokemon        ;;
    h ) usage               ;;
    * ) echo "Unimplemented option chosen." && usage ;;
  esac
done

shift $(($OPTIND - 1))
MESSAGE="${1}"

# Disable wrapping if the option is set, otherwise
# define where to wrap the message.
# word_wrap="-n"
if [ -n "$WORD_WRAP" ]; then
	word_wrap="-W $WORD_WRAP"
fi
echo "w: ${word_wrap}"

# Define which pokemon should be displayed, then call
# cowsay ~or cowthink~.
# TODO: restore cowthink functionality after fine-tuning cowsay
if [ -n "$POKEMON_NAME" ]; then
	cowsay -f "$pokemon_path/$POKEMON_NAME.cow" $word_wrap $MESSAGE
elif [ -n "$COW_FILE" ]; then
	cowsay -f "$COW_FILE" $word_wrap $MESSAGE
else
  a=($pokemon_path/*)
	cowsay -f "${a[$((RANDOM % ${#a[@]}))]}" $word_wrap "$MESSAGE"
fi

# Write the pokemon name, unless requested otherwise.
if [ -z "$DISPLAY_NAME" ]; then
	echo $pokemon_name
fi
