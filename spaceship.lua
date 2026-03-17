local Spaceship = {}
Spaceship.__index = Spaceship

function Spaceship:new(x, y)
    local instance = setmetatable({}, Spaceship)
    
    instance.x = x or 50
    instance.y = y or 300
    instance.speed = 300
    
    instance.width = 60
    instance.height = 30
    
    instance.frames = {}
    instance.currentFrame = 1
    instance.animationTimer = 0
    instance.animationRate = 0.1
    
    instance.bullets = {}
    instance.bulletSpeed = 600
    instance.shootCooldown = 0
    instance.shootRate = 0.2
    
    return instance
end

function Spaceship:load()
    local success1, img1 = pcall(love.graphics.newImage, "assets/Ship01.png")
    local success2, img2 = pcall(love.graphics.newImage, "assets/Ship02.png")
    local success3, img3 = pcall(love.graphics.newImage, "assets/Ship03.png")
    local success4, img4 = pcall(love.graphics.newImage, "assets/Ship04.png")

    if success1 and success2 and success3 and success4 then
        self.frames = {img1, img2, img3, img4}
        self.width = self.frames[1]:getWidth()
        self.height = self.frames[1]:getHeight()
    else
        self.frames = nil
    end
end

function Spaceship:update(dt, windowWidth, windowHeight)
    if love.keyboard.isDown("up", "w") and self.y > 0 then
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown("down", "s") and self.y < windowHeight - self.height then
        self.y = self.y + self.speed * dt
    end
    if love.keyboard.isDown("left", "a") and self.x > 0 then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown("right", "d") and self.x < windowWidth - self.width then
        self.x = self.x + self.speed * dt
    end

    if self.frames then
        self.animationTimer = self.animationTimer + dt
        if self.animationTimer >= self.animationRate then
            self.animationTimer = self.animationTimer - self.animationRate
            self.currentFrame = self.currentFrame + 1
            
            if self.currentFrame > #self.frames then
                self.currentFrame = 1
            end
        end
    end

    if self.shootCooldown > 0 then
        self.shootCooldown = self.shootCooldown - dt
    end

    if love.keyboard.isDown("space") and self.shootCooldown <= 0 then
        self:shoot()
        self.shootCooldown = self.shootRate
    end

    for i = #self.bullets, 1, -1 do
        local b = self.bullets[i]
        b.x = b.x + self.bulletSpeed * dt
        
        if b.x > windowWidth then
            table.remove(self.bullets, i)
        end
    end
end

function Spaceship:shoot()
    local bullet = {
        x = self.x + self.width,
        y = self.y + self.height / 2 - 2,
        width = 15,
        height = 4
    }
    table.insert(self.bullets, bullet)
end

function Spaceship:draw()
    love.graphics.setColor(1, 1, 1)
    
    if self.frames then
        love.graphics.draw(self.frames[self.currentFrame], self.x, self.y)
    else
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end

    love.graphics.setColor(1, 1, 0)
    for _, b in ipairs(self.bullets) do
        love.graphics.rectangle("fill", b.x, b.y, b.width, b.height)
    end
    
    love.graphics.setColor(1, 1, 1)
end

return Spaceship
