import os
import requests
from bs4 import BeautifulSoup
import tqdm

# Define the URLs and image dimensions for each generation
url_data = [
    {"url": "https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_Johto_Pok%C3%A9dex_number", "width": 32, "height": 32, "gen": 2},
    {"url": "https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_Hoenn_Pok%C3%A9dex_number_(Generation_VI)", "width": 40, "height": 40, "gen": 3},
    {"url": "https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_Sinnoh_Pok%C3%A9dex_number", "width": 48, "height": 48, "gen": 4},
    {"url": "https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_Unova_Pok%C3%A9dex_number_(Black_2_and_White_2)", "width": 32, "height": 32, "gen": 5},
    {"url": "https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_Kalos_Pok%C3%A9dex_number", "width": 40, "height": 40, "gen": 6},
    {"url": "https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_Alola_Pok%C3%A9dex_number_(Ultra_Sun_and_Ultra_Moon)", "width": 40, "height": 40, "gen": 7},
]

# Get the names of all PNG files in the directory
png_files = [f for f in os.listdir() if f.endswith('.png')]

# Strip ".png" from the file names and add to a list
pokemon_names = [f[:-4] for f in png_files]

# Loop through the URLs and download the images for each Pokemon
#for url_dict in url_data:
for url_dict in tqdm.tqdm(url_data):
    url = url_dict["url"]
    width = url_dict["width"]
    height = url_dict["height"]
    gen = url_dict["gen"]
    
    # Make a request to the URL and parse the HTML
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    
    # Loop through all the <img> tags in the HTML and find matches for the Pokemon names
    for img in soup.find_all('img'):
        alt = img.get('alt')
        src = img.get('src')
        if alt in pokemon_names and img.get('width') == str(width) and img.get('height') == str(height):
            # Download the image and save it with the name of the original file + the generation number
            image_url = 'https:' + src
            response = requests.get(image_url)
            with open(f'{alt}{gen}.png', 'wb') as f:
                f.write(response.content)