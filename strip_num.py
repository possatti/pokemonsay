# Description: Strips the numbers from the end of the file names of the images
# This is used to get rid of the generation names from the file names once you've sifted through the images and removed the ones you don't want

import os
import re
from tqdm import tqdm

dir_path = os.path.join(os.getcwd(), "scrapped-data", "pokemon_images")

for filename in tqdm(os.listdir(dir_path), desc="Renaming files"):
    if filename.endswith(".png") and re.search(r'\d+', filename):
        new_filename = re.sub(r'\d+', '', filename)
        os.rename(os.path.join(dir_path, filename), os.path.join(dir_path, new_filename))
