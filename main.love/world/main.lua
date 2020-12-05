local json = require "../json/main"

local world = {}

function initWorld()
    local cursor = {
        sx = 0,
        sy = 0,
        x = 0,
        y = 0
    }
    -- map size: 50 au (meters)
    local map = {
        x = 149597870700 * 50,
        y = 149597870700 * 50
    }
    local camera = {
        x = 0,
        y = 0,
        zoom = 1,
        angle = 0,
        sx = 0,
        sy = 0,
        sw = love.graphics.getWidth(),
        sh = love.graphics.getHeight()
    }
    local objects = {
        rocket = {
            x = 0,
            y = 0,
            radius = 5,
            mass = 10,
            angle = 0,
            controlled = 1,
            vx = 0,
            vy = 0,
            acceleration = 2,
            xs = 0,
            ys = 0,
            vertexes = {-5, -5, 0, 5, 5, -5}
        }
    }
    return map, camera, objects, cursor
end

return world
