local Parallax = require("parallax")
local Spaceship = require("spaceship")

local gameState = "start"
local parallax
local spaceship
local windowWidth
local windowHeight

local playButton = {
    x = 0,
    y = 0,
    width = 200,
    height = 60
}

function love.load()
    parallax = Parallax:new()
    parallax:load()
    
    windowWidth = parallax:getWidth()
    windowHeight = parallax:getHeight()
    
    love.window.setMode(windowWidth, windowHeight, { resizable = false })
    love.window.setTitle("SpaceShip - Parallax Scrolling")
   
    spaceship = Spaceship:new(50, windowHeight / 2)
    spaceship:load()

    playButton.x = (windowWidth - playButton.width) / 2
    playButton.y = windowHeight / 2 + 50
end

function love.update(dt)
    if gameState == "playing" then
        parallax:update(dt)
	spaceship:update(dt, windowWidth, windowHeight)
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    
    if gameState == "start" then
        parallax:draw()
        drawStartScreen()
    elseif gameState == "playing" then
        parallax:draw()
	spaceship:draw()
    end
end

function drawStartScreen()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("SPACESHIP", 0, windowHeight / 3, windowWidth, "center")
    
    local font = love.graphics.getFont()
    local titleFont = love.graphics.newFont(48)
    love.graphics.setFont(titleFont)
    love.graphics.printf("SPACESHIP", 0, windowHeight / 3, windowWidth, "center")
    love.graphics.setFont(font)
    
    local mouseX, mouseY = love.mouse.getPosition()
    local isHovering = mouseX >= playButton.x and mouseX <= playButton.x + playButton.width
        and mouseY >= playButton.y and mouseY <= playButton.y + playButton.height
    
    if isHovering then
        love.graphics.setColor(0.3, 0.7, 1)
    else
        love.graphics.setColor(0.2, 0.5, 0.8)
    end
    love.graphics.rectangle("fill", playButton.x, playButton.y, playButton.width, playButton.height, 10, 10)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("PLAY", playButton.x, playButton.y + playButton.height / 2 - 10, playButton.width, "center")
end

function love.mousepressed(x, y, button)
    if button == 1 and gameState == "start" then
        if x >= playButton.x and x <= playButton.x + playButton.width
            and y >= playButton.y and y <= playButton.y + playButton.height then
            gameState = "playing"
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        if gameState == "playing" then
            gameState = "start"
            parallax:reset()
        else
            love.event.quit()
        end
    end
end
