WIDTH, HEIGHT = love.graphics.getDimensions()

local Star = require('star')

local stars = {}

function love.load()
    love.window.setTitle('starfield')

    for i = 1, 400 do
        stars[i] = Star()
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    for _, star in pairs(stars) do
        star:update(dt)
    end
end

function love.draw()
    love.graphics.translate(WIDTH / 2, HEIGHT / 2)
    love.graphics.clear(0, 0, 0, 1)

    for _, star in pairs(stars) do
        star:draw()
    end
end
