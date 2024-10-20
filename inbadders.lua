-- Main Love2D script
function love.load()
    -- Constants
    CANVASWIDTH = 800
    CANVASHEIGHT = 600

    -- Key constants
    KEY_LEFT = "left"
    KEY_RIGHT = "right"
    KEY_SPACE = "space"

    -- Initialize game variables
    SPACESHIP = { x = CANVASWIDTH / 2 - 20, y = CANVASHEIGHT - 50 }
    INVADER = { x = 50, y = 50, speed = 2, direction = 1 }
    BULLETS = {}
    for i = 1, 10 do
        BULLETS[i] = { x = 0, y = 0, active = false }
    end
    GAMEOVER = false
    SCORE = 0

    -- Load sprites
    SPACESHIP.sprite = love.graphics.newImage("spaceship.png")
    INVADER.sprite = love.graphics.newImage("invader.png")
    
    -- Create sprites from pixmap definitions
    createSprites()
end

function createSprites()
    -- Define colors according to Pico8 palette
    local colors = {
        [0] = { 0, 0, 0 },
        [1] = { 29, 43, 83 },
        [2] = { 126, 37, 83 },
        [3] = { 0, 135, 81 },
        [4] = { 171, 82, 54 },
        [5] = { 95, 87, 79 },
        [6] = { 194, 195, 199 },
        [7] = { 255, 241, 232 },
        [8] = { 255, 0, 77 },
        [9] = { 255, 163, 0 },
        [10] = { 255, 236, 39 },
        [11] = { 0, 228, 54 },
        [12] = { 41, 173, 255 },
        [13] = { 131, 118, 156 },
        [14] = { 255, 119, 168 },
        [15] = { 255, 204, 170 }
    }

    -- Create spaceship sprite
    SPACESHIP.pixels = {
        {0,0,12, 7,  7, 12, 0, 0},
        {0,7,  7,  7,  7,  7, 7, 0},
        {12,7,  7,  7,  7,  7, 7, 12},
        {12,7,  0,  7,  7,  0, 7, 12},
        {12,0,  0,  7,  7,  0, 0, 12}
    }
    SPACESHIP.image = createSpriteImage(SPACESHIP.pixels, colors)

    -- Create invader sprite
    INVADER.pixels = {
        {0, 2, 2, 2, 2, 2, 2, 0},
        {2, 2, 0, 0, 0, 0, 2, 2},
        {2, 2, 11, 11, 11, 11, 2, 2},
        {2, 0, 2, 2, 2, 2, 0, 2},
        {2, 0, 2, 0, 0, 2, 0, 2}
    }
    INVADER.image = createSpriteImage(INVADER.pixels, colors)
end

function createSpriteImage(pixels, colors)
    local width, height = #pixels[1], #pixels
    local imageData = love.image.newImageData(width, height)

    for y = 1, height do
        for x = 1, width do
            local colorIndex = pixels[y][x]
            if colorIndex > 0 then
                local r, g, b = unpack(colors[colorIndex])
                imageData:setPixel(x - 1, y - 1, r / 255, g / 255, b / 255, 1)
            end
        end
    end

    return love.graphics.newImage(imageData)
end

function love.update(dt)
    if not GAMEOVER then
        moveSpaceship()
        moveInvader()
        moveBullets()
        checkGameOver()
    end
end

function love.draw()
    if GAMEOVER then
        drawGameOver()
    else
        love.graphics.clear(0, 0, 0)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(SPACESHIP.image, SPACESHIP.x, SPACESHIP.y, 0, 8, 8)
        love.graphics.draw(INVADER.image, INVADER.x, INVADER.y, 0, 8, 8)
        drawBullets()
        drawScore()
    end
end

function drawScore()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("SCORE: " .. SCORE, 10, 10)
end

function drawGameOver()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("GAME OVER", 0, CANVASHEIGHT / 2 - 30, CANVASWIDTH, "center")
    love.graphics.printf("SCORE: " .. SCORE, 0, CANVASHEIGHT / 2 + 10, CANVASWIDTH, "center")
end

function moveSpaceship()
    if love.keyboard.isDown(KEY_LEFT) then
        SPACESHIP.x = math.max(SPACESHIP.x - 5, 0)
    end
    if love.keyboard.isDown(KEY_RIGHT) then
        SPACESHIP.x = math.min(SPACESHIP.x + 5, CANVASWIDTH - 40)
    end
    if love.keyboard.isDown(KEY_SPACE) then
        shootBullet()
    end
end

function shootBullet()
    for i = 1, #BULLETS do
        if not BULLETS[i].active then
            BULLETS[i].x = SPACESHIP.x + 20
            BULLETS[i].y = SPACESHIP.y - 10
            BULLETS[i].active = true
            break
        end
    end
end

function moveBullets()
    for i = 1, #BULLETS do
        if BULLETS[i].active then
            BULLETS[i].y = BULLETS[i].y - 5
            if BULLETS[i].y < 0 then
                BULLETS[i].active = false
            elseif BULLETS[i].y < INVADER.y + 5 and BULLETS[i].x > INVADER.x and BULLETS[i].x < INVADER.x + 40 then
                BULLETS[i].active = false
                SCORE = SCORE + 100
                INVADER.y = 600 -- Move invader off-screen
            end
        end
    end
end

function drawBullets()
    for i = 1, #BULLETS do
        if BULLETS[i].active then
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("fill", BULLETS[i].x, BULLETS[i].y, 2, 10) -- Draw bullet
        end
    end
end

function moveInvader()
    INVADER.x = INVADER.x + INVADER.speed * INVADER.direction
    if INVADER.x < 0 or INVADER.x > CANVASWIDTH - 40 then
        INVADER.direction = -INVADER.direction
        INVADER.y = INVADER.y + 10 -- Move invader down
    end
end

function checkGameOver()
    if INVADER.y > CANVASHEIGHT then
        GAMEOVER = true
    end
end

function love.keypressed(key)
    if GAMEOVER and key == "return" then
        -- Restart the game
        love.load()
    end
end
