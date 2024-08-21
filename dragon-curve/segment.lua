local Base = require('base')
local Vector = require('vector')

local Segment = Base:extend()

function Segment:constructor(x1, y1, x2, y2)
    self.a = Vector.new(x1, y1)
    self.b = Vector.new(x2, y2)
end

function Segment:draw()
    love.graphics.line(self.a.x, self.a.y, self.b.x, self.b.y)
end

return Segment
