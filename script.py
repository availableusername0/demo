try:
    import pygame
except:
    import os
    os.system("pip install pygame") 
    import pygame   
import random

pygame.init()

# Fullscreen mode to lock the user into the prank window
infoObject = pygame.display.Info()
screen_width = infoObject.current_w
screen_height = infoObject.current_h
screen = pygame.display.set_mode((screen_width, screen_height), pygame.FULLSCREEN)
pygame.display.set_caption("Python Prank!")

font = pygame.font.SysFont("Arial", 100)
clock = pygame.time.Clock()

FPS = 10  # Frame rate

# Define keys that allow exiting (e.g., pressing 'Ctrl+Alt+Q' could be a hidden escape)
allowed_keys = [pygame.K_LCTRL, pygame.K_LALT, pygame.K_q]
pressed_keys = set()

running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.KEYDOWN:
            pressed_keys.add(event.key)

            # Check for secret key combination to exit (Ctrl + Alt + Q)
            if {pygame.K_LCTRL, pygame.K_LALT, pygame.K_q}.issubset(pressed_keys):
                running = False
        elif event.type == pygame.KEYUP:
            pressed_keys.discard(event.key)
        
        # Block all other keypresses (except defined exit keys)
        if event.type == pygame.KEYDOWN and event.key not in allowed_keys:
            pass  # Do nothing for all other key presses

    text_color = (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
    text = font.render(":-) CSCPSUT TOOK OVER YOUR DEVICE! (-: )", True, text_color)

    x_offset = random.randint(-50, 50)
    y_offset = random.randint(-50, 50)
    text_rect = text.get_rect()
    text_rect.center = (screen_width // 2 + x_offset, screen_height // 2 + y_offset)

    screen.fill((0, 0, 0))
    screen.blit(text, text_rect)
    pygame.display.flip()

    clock.tick(FPS)

# Quit Pygame properly when loop ends
pygame.quit()
