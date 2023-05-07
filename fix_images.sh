#!/bin/sh

i = 0

#for image in ./scrapped-data/pokemon_images/*.png
for image in ./scrapped-data/good/*.png
do
	# Mirror the image in the horizontal direction so that the pokemon will be looking to the right.
	convert -flop "$image" "$image"

	convert "$image" -resize 50x50 "$image"

	# Trim the useless empty space around the pokemon.
	convert -trim "$image" "$image"
	((i=i+1))
	echo "$i"
done
