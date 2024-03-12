from PIL import Image
import os

# Define a function to process the images
def process_images(file_path, prefix='', output_folder="gen_9"):
    try:
        # Create the output directory if it doesn't exist
        os.makedirs(output_folder, exist_ok=True)
        
        # Open the image file
        with Image.open(file_path) as img:
            # Calculate the number of sprites in the image based on the dimensions and sprite size
            num_sprites_horizontal = img.width // 32
            num_sprites_vertical = img.height // 32
            
            # Loop over the image and extract each sprite
            for y in range(num_sprites_vertical):
                for x in range(num_sprites_horizontal):
                    # Define the box to crop
                    left = x * 32
                    top = y * 32
                    right = left + 32
                    bottom = top + 32
                    box = (left, top, right, bottom)
                    
                    # Crop the image to the box
                    sprite = img.crop(box)
                    
                    # Define the filename for the sprite
                    sprite_num = y * num_sprites_horizontal + x + 1
                    filename = f"{prefix}{sprite_num}.png"
                    
                    # Save the sprite to the output folder
                    sprite.save(os.path.join(output_folder, filename))
                    
        return "Images processed successfully."
    except Exception as e:
        return str(e)

# Process the first image
message_gen_9 = process_images('gen_9.png')

# Process the second image
message_gen_9_shiny = process_images('gen_9_shiny.png', 'shiny-1')

(message_gen_9, message_gen_9_shiny)
