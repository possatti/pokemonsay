#!/bin/sh

for image in ./scrapped-data/*.png
do
	# Mirror the image in the horizontal direction so that the pokemon will be looking to the right.
	convert -flop "$image" "$image"

	# Resize the image to 50x50 pixels (or close to that if image isn't a perfect square).
	convert "$image" -resize 50x50 "$image"

	# Trim the useless empty space around the pokemon.
	convert -trim "$image" "$image"
done
