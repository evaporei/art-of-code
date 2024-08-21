local Drop = {}
Drop.__index = Drop

local speed = 200

function Drop.new(x, y)
    local self = {x = x, y = y}

    setmetatable(self, Drop)
    return self
end

function Drop:update(dt)
    self.y = self.y + speed * dt
    if self.y > love.graphics.getHeight() then
        self.y = 0
    end
end

function Drop:draw()
    love.graphics.setColor(0xEE / 255, 0x82 / 255, 0xEE / 255, 1)
    -- love.graphics.setLineWidth(3)
    love.graphics.line(self.x, self.y, self.x, self.y + 10)
end

return Drop
