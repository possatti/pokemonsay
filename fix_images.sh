#!/bin/sh

for image in ./scrapped-data/*.png
do
	# Mirror the image in the horizontal direction so that the pokemon will be looking to the right.
	convert -flop "$image" "$image"

	# Trim the useless empty space around the pokemon.
	convert -trim "$image" "$image"
done
