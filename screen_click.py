# Automated center clicking for clicking games

import pyautogui
import time
import keyboard  # Install using: pip install keyboard

screen_width, screen_height = pyautogui.size()

center_x = screen_width // 2
center_y = screen_height // 2

try:
    while True:
        if keyboard.is_pressed('q'):  # Press 'q' to stop the script
            print("Stopping script.")
            break
        pyautogui.click(center_x, center_y)
        time.sleep(0.008)  # 10 milliseconds
except KeyboardInterrupt:
    print("Script stopped.")