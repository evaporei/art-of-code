local Base = require('base')

local Star = Base:extend()

local SPEED = 100

function Star:constructor()
    self.x = math.random(-WIDTH / 2, WIDTH / 2)
    self.y = math.random(-HEIGHT / 2, HEIGHT / 2)
    self.z = math.random(WIDTH)
    self.pz = self.z
end

function Star:reset()
    self.x = math.random(-WIDTH / 2, WIDTH / 2)
    self.y = math.random(-HEIGHT / 2, HEIGHT / 2)
    self.z = WIDTH
    self.pz = self.z
end

function Star:update(dt)
    self.z = self.z - SPEED * dt
    if self.z < 1 then
        self:reset()
    end
end

-- https://p5js.org/reference/p5/map/
local function map(value, start1, stop1, start2, stop2)
    return (value - start1) / (stop1 - start1) * (stop2 - start2) + start2
end

function Star:draw()
    local sx = self.x / self.z * WIDTH
    local sy = self.y / self.z * WIDTH

    local r = map(self.z, 0, WIDTH, 4, 0)

    love.graphics.circle('fill', sx, sy, r)

    local px = self.x / self.pz * WIDTH
    local py = self.y / self.pz * WIDTH

    love.graphics.line(px, py, sx, sy)
end

return Star
