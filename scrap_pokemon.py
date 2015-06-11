#!/usr/bin/python3

import re
import sys
import html
import urllib.request

# Load the pokemon sprites page.
with open('scrapped-data/bulbapedia.html', 'r') as page:
	html_page = "".join(page.readlines());

# Find all pokemon name and image urls.
image_regex = r'<img alt="(.*)" src="(http://cdn.bulbagarden.net/upload/.*\.png)" width="40" height="40" />'
all_pokemon = re.findall(image_regex, html_page)

# Save the image of each pokemon.
for pokemon in all_pokemon:
	# Unpack the tuple data.
	name, image_url = pokemon

	# Clean HTML escape sequences in the name
	name = html.unescape(name)

	# Set file path for the image.
	file_path = './scrapped-data/' + name + '.png'

	# Tell the user what we are doing here.
	print('Downloading "{}" image to "{}"...'.format(name, file_path))

	# Download the image.
	with open(file_path, 'wb') as pokemon_file:
		with urllib.request.urlopen(image_url) as pokemon_image:
			pokemon_file.write(pokemon_image.read())
