local Drop = {}
Drop.__index = Drop

function Drop.new(x, y)
    local self = {
        x = x,
        y = y,
    }

    -- 1.0 to 2.0
    self.z = math.random()
    -- 100 to 300
    self.yspeed = 400 * (self.z + math.random() / 2)
    -- 10 to 20
    self.length = 10 * (self.z + 1)

    setmetatable(self, Drop)
    return self
end

function Drop:update(dt)
    self.y = self.y + self.yspeed * dt
    if self.y > love.graphics.getHeight() then
        self.y = 0
        self.x = math.random(love.graphics.getWidth())
    end
end

function Drop:draw()
    love.graphics.setColor(0xEE / 255, 0x82 / 255, 0xEE / 255, 1)
    love.graphics.setLineWidth(self.z * 2)
    love.graphics.line(self.x, self.y, self.x, self.y + self.length)
end

return Drop
