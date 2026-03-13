local Parallax = {}
Parallax.__index = Parallax

function Parallax:new()
    local instance = setmetatable({}, Parallax)
    
    instance.stars = {}
    instance.farback = {}
    instance.starsScroll = 0
    instance.farbackScroll = 0
    instance.starsSpeed = 20
    instance.farbackSpeed = 40
    
    return instance
end

function Parallax:load()
    self.stars.image = love.graphics.newImage("assets/Stars.png")
    self.stars.image:setWrap("repeat", "clamp")
    
    self.farback.image1 = love.graphics.newImage("assets/Farback01.png")
    self.farback.image2 = love.graphics.newImage("assets/Farback02.png")
    self.farback.width = self.farback.image1:getWidth() + self.farback.image2:getWidth()
end

function Parallax:update(dt)
    self.starsScroll = self.starsScroll + self.starsSpeed * dt
    if self.starsScroll >= self.stars.image:getWidth() then
        self.starsScroll = self.starsScroll - self.stars.image:getWidth()
    end
    
    self.farbackScroll = self.farbackScroll + self.farbackSpeed * dt
    if self.farbackScroll >= self.farback.width then
        self.farbackScroll = self.farbackScroll - self.farback.width
    end
end

function Parallax:draw()
    love.graphics.setColor(1, 1, 1)
    
    local img1w = self.farback.image1:getWidth()
    local img2w = self.farback.image2:getWidth()
    local totalWidth = self.farback.width
    
    local scroll = self.farbackScroll % totalWidth
    
    love.graphics.draw(self.farback.image1, -scroll, 0)
    love.graphics.draw(self.farback.image2, -scroll + img1w, 0)
    
    love.graphics.draw(self.farback.image1, -scroll + totalWidth, 0)
    love.graphics.draw(self.farback.image2, -scroll + totalWidth + img1w, 0)
    
    love.graphics.draw(self.stars.image, -self.starsScroll, 0)
    love.graphics.draw(self.stars.image, -self.starsScroll + self.stars.image:getWidth(), 0)
end

function Parallax:reset()
    self.starsScroll = 0
    self.farbackScroll = 0
end

function Parallax:getWidth()
    return self.stars.image:getWidth()
end

function Parallax:getHeight()
    return self.stars.image:getHeight()
end

return Parallax