#!/bin/sh

#
# This script scraps some pokémon pictures from Bulbapedia.
#

bulbapedia_page_url="http://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_Johto_Pok%C3%A9dex_number"
bulbapedia_page_name="bulbapedia.html"
scrap_folder="`pwd`/scrapped-data"

# Make sure the directory for the scrapped data is there.
mkdir -p "$scrap_folder"

# Download the bulbapedia page if it doesn't already.
if [ ! -e "scrapped-data/bulbapedia.html" ]; then
	echo "  > Downloading '$bulbapedia_page_url' to '$scrap_folder/$bulbapedia_page_name' ..."
	wget "$bulbapedia_page_url" -O "$scrap_folder/$bulbapedia_page_name" -q
	echo "  > Downloaded."
fi

# Dear furure me,
#
#   If you are in need to maintain this part of the code... I am
# realy sorry for you (T.T). This was the best I could do... But
# I will try to explain things here a little bit.
#   'cat' will read the file and pipe its output to 'sed'. 'sed'
# will filter the html searching for the Pokémon name and its
# image url. 'sed' will output the Pokémons in this format:
# "<POKEMON_NAME>=<POKEMON_URL>". And the output of 'sed' will be
# stored in a variable we will use later.
#   Then, the content of the variable will be read one line at a
# time in the for loop. Within the for loop, I extract the pokemon
# name and the url from the read line. And then, it just downloads
# the content of the url to a file.
#   Again... I'm sorry for all the trouble. But I hope you will
# grow stronger and may be able to turn this code into something
# more readable.
#
#                                                     Kind regards,
#                                           Yourself from the past.

pokemon_images=$(
	cat "$scrap_folder/$bulbapedia_page_name" | \
	sed -nr 's;^.*<img alt="(.*)" src="(http://cdn.bulbagarden.net/upload/.*\.png)" width="40" height="40" />.*$;\1=\2;p' \
)

for line in $pokemon_images; do
	pokemon_name="${line%=*}"
	pokemon_url="${line#*=}"

	# Unescape HTML characters... Damn "Farfetch&#39;d".
	pokemon_name=$(echo "$pokemon_name" | sed "s/&#39;/'/")

	# If wget is interrupted by a SIGINT or something, it will
	# leave a broken file. Let's remove it and exit in case we
	# receive a signal like this.
	# Signals: (1) SIGHUP; (2) SIGINT; (15) SIGTERM.
	trap "rm $scrap_folder/$pokemon_name.png; echo Download of $pokemon_name was cancelled; exit" 1 2 15

	echo "  > Downloading '$pokemon_name' from '$pokemon_url' to '$scrap_folder/$pokemon_name.png' ..."
	wget "$pokemon_url" -O "$scrap_folder/$pokemon_name.png" -q
done
