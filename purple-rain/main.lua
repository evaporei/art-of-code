local Drop = require('drop')

local rain = {}

function love.load()
    love.window.setTitle('purple rain')

    math.randomseed(os.time())

    local width, height = love.graphics.getDimensions()

    for _ = 1, 100 do
        local drop = Drop.new(math.random(width), math.random(height))
        table.insert(rain, drop)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    for _, drop in pairs(rain) do
        drop:update(dt)
    end
end

function love.draw()
    love.graphics.clear(1, 1, 1, 1)
    for _, drop in pairs(rain) do
        drop:draw()
    end
end
