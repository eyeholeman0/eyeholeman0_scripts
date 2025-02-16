import pyautogui
import time
import keyboard  # Install using: pip install keyboard

# Get the screen size
screen_width, screen_height = pyautogui.size()

# Calculate the center of the screen
center_x = screen_width // 2
center_y = screen_height // 2

# Loop to click every 10ms
try:
    while True:
        if keyboard.is_pressed('q'):  # Press 'q' to stop the script
            print("Stopping script.")
            break
        pyautogui.click(center_x, center_y)
        time.sleep(0.008)  # 10 milliseconds
except KeyboardInterrupt:
    print("Script stopped.")