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
    local visuals = {
        size = 256,
        subdivisions = 4,
        color = {0, 0, 0},
        drawScale = false,
        xColor = {255, 255, 0},
        yColor = {0, 255, 255},
        fadeFactor = 0.3,
        textFadeFactor = 0.5,
        hideOrigin = true,
        interval = 100
    }
    local objects = {
        planet1 = {
            x = -100,
            y = 0,
            radius = 75,
            mass = 6 * 10 ^ 11,
            angle = 0,
            vx = 0,
            vy = -400,
            acceleration = 0,
            controlled = 0,
            xs = 0,
            ys = 0
        },
        planet2 = {
            x = 100,
            y = 0,
            radius = 75,
            mass = 6 * 10 ^ 11,
            angle = 0,
            vx = 0,
            vy = 400,
            acceleration = 0,
            controlled = 0,
            xs = 0,
            ys = 0
        },    
        sat1 = {
            x = 0,
            y = -500,
            radius = 5,
            mass = 10,
            angle = 0,
            vx = 600,
            vy = 0,
            acceleration = 2,
            controlled = 0,
            xs = 0,
            ys = 0
        },
        sat2 = {
            x = 0,
            y = -550,
            radius = 5,
            mass = 10,
            angle = 0,
            vx = 600,
            vy = 0,
            acceleration = 2,
            controlled = 1,
            xs = 0,
            ys = 0
        }
    }
    return map, camera, visuals, objects, cursor
end

return world
