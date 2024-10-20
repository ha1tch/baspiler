import pygame
import sys
import random

# Constants
CANVASWIDTH = 800
CANVASHEIGHT = 600
KEY_LEFT = 37
KEY_RIGHT = 39
KEY_SPACE = 32

# Pico8 Palette
PALETTE = [
    (0, 0, 0),      # 0: black
    (29, 43, 83),   # 1: dark-blue
    (126, 37, 83),  # 2: dark-purple
    (0, 135, 81),   # 3: dark-green
    (171, 82, 54),  # 4: brown
    (95, 87, 79),   # 5: dark-grey
    (194, 195, 199),# 6: light-grey
    (255, 241, 232),# 7: white
    (255, 0, 77),   # 8: red
    (255, 163, 0),  # 9: orange
    (255, 236, 39), # 10: yellow
    (0, 228, 54),   # 11: green
    (41, 173, 255), # 12: blue
    (131, 118, 156),# 13: lavender
    (255, 119, 168),# 14: pink
    (255, 204, 170) # 15: light-peach
]

# Sprite definitions
SPACESHIP_PIXMAP = [
    [0, 0, 12, 7, 7, 12, 0, 0],
    [0, 7, 7, 7, 7, 7, 7, 0],
    [12, 7, 7, 7, 7, 7, 7, 12],
    [12, 7, 0, 7, 7, 0, 7, 12],
    [12, 0, 0, 7, 7, 0, 0, 12]
]

INVADER_PIXMAP = [
    [0, 2, 2, 2, 2, 2, 2, 0],
    [2, 2, 0, 0, 0, 0, 2, 2],
    [2, 2, 11, 11, 11, 11, 2, 2],
    [2, 0, 2, 2, 2, 2, 0, 2],
    [2, 0, 2, 0, 0, 2, 0, 2]
]

# Bullet definition
class Bullet:
    def __init__(self):
        self.x = 0
        self.y = 0
        self.active = False

# Game class
class Game:
    def __init__(self):
        self.spaceship_x = CANVASWIDTH / 2 - 20
        self.spaceship_y = CANVASHEIGHT - 50
        self.invader_x = 50
        self.invader_y = 50
        self.invader_speed = 2
        self.invader_direction = 1  # 1 for right, -1 for left
        self.game_over = False
        self.score = 0
        self.bullets = [Bullet() for _ in range(10)]
    
    def draw_sprite(self, surface, pixmap, x, y):
        for row_idx, row in enumerate(pixmap):
            for col_idx, color_index in enumerate(row):
                if color_index != 0:  # Assuming 0 is transparent
                    pygame.draw.rect(surface, PALETTE[color_index], 
                                     (x + col_idx * 8, y + row_idx * 8, 8, 8))

    def draw_game_over(self, surface):
        font = pygame.font.SysFont("Arial", 30)
        text = font.render("GAME OVER", True, PALETTE[7])
        surface.blit(text, (CANVASWIDTH / 2 - text.get_width() / 2, CANVASHEIGHT / 2))
        
        score_text = font.render(f"SCORE: {self.score}", True, PALETTE[7])
        surface.blit(score_text, (CANVASWIDTH / 2 - score_text.get_width() / 2, CANVASHEIGHT / 2 + 40))

    def draw_score(self, surface):
        font = pygame.font.SysFont("Arial", 20)
        score_text = font.render(f"SCORE: {self.score}", True, PALETTE[7])
        surface.blit(score_text, (10, 10))

    def move_bullets(self):
        for bullet in self.bullets:
            if bullet.active:
                bullet.y -= 5  # Move bullet up
                if bullet.y < 0:
                    bullet.active = False
                if bullet.active and bullet.y < self.invader_y + 5 and \
                   self.invader_x < bullet.x < self.invader_x + 40:
                    bullet.active = False  # Deactivate bullet
                    self.score += 100      # Increase score
                    self.invader_y = 600   # Move invader off-screen

    def move_spaceship(self):
        keys = pygame.key.get_pressed()
        if keys[pygame.K_LEFT]:
            self.spaceship_x -= 5
        if keys[pygame.K_RIGHT]:
            self.spaceship_x += 5
        if keys[pygame.K_SPACE]:
            self.shoot_bullet()

    def shoot_bullet(self):
        for bullet in self.bullets:
            if not bullet.active:
                bullet.x = self.spaceship_x + 20
                bullet.y = self.spaceship_y - 10
                bullet.active = True
                break

    def move_invader(self):
        self.invader_x += self.invader_speed * self.invader_direction
        if self.invader_x < 0 or self.invader_x > CANVASWIDTH - 40:
            self.invader_direction = -self.invader_direction
            self.invader_y += 10  # Move invader down

    def check_game_over(self):
        if self.invader_y > CANVASHEIGHT:
            self.game_over = True

    def run(self):
        pygame.init()
        screen = pygame.display.set_mode((CANVASWIDTH, CANVASHEIGHT))
        clock = pygame.time.Clock()

        while True:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    pygame.quit()
                    sys.exit()

            if not self.game_over:
                screen.fill(PALETTE[0])  # Clear screen with black
                self.draw_score(screen)
                self.draw_sprite(screen, SPACESHIP_PIXMAP, self.spaceship_x, self.spaceship_y)
                self.draw_sprite(screen, INVADER_PIXMAP, self.invader_x, self.invader_y)
                
                for bullet in self.bullets:
                    if bullet.active:
                        self.draw_sprite(screen, [[11]], bullet.x, bullet.y)

                self.move_spaceship()
                self.move_bullets()
                self.move_invader()
                self.check_game_over()
            else:
                self.draw_game_over(screen)

            pygame.display.flip()
            clock.tick(60)  # Frame rate

if __name__ == "__main__":
    Game().run()

