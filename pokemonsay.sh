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
    -w, --word-wrap COLUMN
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
      The message for chosen Pokémon to say. If this is not provided the Pokémon will read from STDIN
"
  exit 0
}

list_pokemon() {
	echo "Pokémon available in '$POKEMON/':"
	cat ./Poké.dex
	exit 0
}

# Disable wrapping by default
WORD_WRAP="-n"

while getopts ":p:f:wnNlh" Option ; do
  case $Option in
    f ) COWFILE="$OPTARG" ;;
    p ) I_CHOOSE="$OPTARG" ;;
    w ) WORD_WRAP="-W $OPTARG" ;;
    n ) DISABLE_WRAP=true   ;;
    N ) DISABLE_NAME=true   ;;
    l ) list_pokemon        ;;
    h ) usage               ;;
    * ) echo "Unimplemented option chosen." && usage ;;
  esac
done

shift $(($OPTIND - 1))
MESSAGE="${1}"

# Define which pokemon should be displayed, then call cowsay or cowthink
# TODO: restore cowthink after fine-tuning cowsay
if [ -n "$I_CHOOSE" ]; then
	cowsay -f "$PWD/cows/$I_CHOOSE.cow" $WORD_WRAP "$MESSAGE"
elif [ -n "$COW_FILE" ]; then
	cowsay -f "$COW_FILE" $WORD_WRAP "$MESSAGE"
else
  a=(cows/*)
  I_CHOOSE=${a[$((RANDOM % ${#a[@]}))]}
  I_CHOOSE=${I_CHOOSE#cows/}
  I_CHOOSE=${I_CHOOSE%.cow}
	cowsay -f $PWD/cows/$I_CHOOSE.cow $WORD_WRAP "$MESSAGE"
fi

# Write the pokemon name, unless requested otherwise.
[ -n "$DISABLE_NAME" ] && echo $I_CHOOSE

