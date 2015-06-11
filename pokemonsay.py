#!/usr/bin/python3

import re
import os
import sys
import random
from subprocess import Popen, PIPE

pokemon_path = 'cows'

def random_pokemon():
	filenames = os.listdir(pokemon_path)
	filename = random.choice(filenames) #change dir name to whatever
	file_path = os.path.join(pokemon_path, filename)
	return file_path

# Chooses a random pokemon.
pokemon_file_path = random_pokemon()
pokemon_name = re.findall(r'[\\/](.*)\.cow', pokemon_file_path)[0]

# Start a new subprocess to run cowsay
cowsay = Popen(['cowsay', '-f', pokemon_file_path], stdin=PIPE, stdout=PIPE, stderr=PIPE)

# Get the output from stdout and stdin from the subprocess.
out, err = cowsay.communicate(input=sys.stdin.read().encode())

# Output cowsay's output and errors
print(err.decode(), file=sys.stderr)
print(out.decode())

# Print the pokemon name
print(pokemon_name)