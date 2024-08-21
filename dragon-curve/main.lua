WIDTH, HEIGHT = love.graphics.getDimensions()

local Segment = require('segment')

local segments = {}

function love.load()
    love.window.setTitle('dragon curve')

    table.insert(segments, Segment(WIDTH / 2, HEIGHT / 2 - 50, WIDTH / 2, HEIGHT / 2 + 50))
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    for _, segment in pairs(segments) do
        segment:draw()
    end
end
