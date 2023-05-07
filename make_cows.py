# This is only here because I had trouble building img2xterm (which is now fixed with all the dependencies listed here: https://github.com/Huckdirks/img2xterm) so I had to use Charc0al's cowsay file converter instead, but really didn't want to do it manually for the whole pokédex
# This can be used over make_cows.sh, but I think the results from make_cows.sh (by using img2xterm) are better

# This also assumes that you've downloaded selenium and have the chromedriver in your PATH

import os
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import tqdm

def automate_upload_convert(file_path: str, driver: webdriver.Chrome):
    url = "https://charc0al.github.io/cowsay-files/converter/"

    # Initialize the WebDriver
    driver.get(url)

    # Upload the file
    choose_file_button = driver.find_element(By.ID, "file")
    choose_file_button.send_keys(file_path)

    # Click the Convert! button
    convert_button = driver.find_element(By.XPATH, "//button[contains(text(), 'Convert!')]")
    convert_button.click()

    # Wait for the download to complete (increase time if needed)
    time.sleep(0.5)


if __name__ == "__main__":
    files_directory = os.path.join(os.getcwd(), "scrapped-data")
    driver = webdriver.Chrome()
    for file in tqdm.tqdm(os.listdir(files_directory)):
        file_to_upload = os.path.join(files_directory, file)
        automate_upload_convert(file_to_upload, driver)
    driver.quit()