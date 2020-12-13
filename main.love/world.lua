local world = {}

function initWorld()
    local cursor = {
        sx = 0,
        sy = 0,
        x = 0,
        y = 0,
        tempx = 0,
        tempy = 0
    }
    -- map size: 1 au (meters)
    local map = {
        x = 149597870700,
        y = 149597870700
    }
    local settings = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        zoom = 1,
        angle = 0,
        sx = 0,
        sy = 0,
        sw = love.graphics.getWidth(),
        sh = love.graphics.getHeight()
    }
    local objects = {
        moon = {
            x = love.graphics.getWidth() / 2,
            y = love.graphics.getHeight() / 2,
            radius = 210,
            mass = 7 * 10 ^ 11,
            type = "planet",
            angle = 0,
            controlled = 0,
            vx = 0,
            vy = 0,
            va = 0.02,
            acceleration = 0,
            rotation = math.pi,
            image = love.graphics.newImage("assets/moon.png"),
            xs = 0,
            ys = 0
        }
    }
    local state = {
        stop = 0
    }
    return map, settings, objects, cursor, state
end

return world
