local world = {}

function initWorld()
    local cursor = {
        sx = 0,
        sy = 0,
        wx = 0,
        wy = 0 
    }
    local map = {
        x = 14959787070000,
        y = 14959787070000
    }
    local camera = {
        x = 341,
        y = 192,
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
        planet = {
            x = 0,
            y = 0,
            radius = 75,
            mass = 6 * 10 ^ 11,
            angle = 0,
            fgravity = 0,
            agravity = 0,
            vx = 0,
            vy = 0,
            acceleration = 0,
            xs = 0,
            ys = 0
        },    
        sat1 = {
            x = 0,
            y = -300,
            radius = 5,
            mass = 10,
            angle = 0,
            fgravity = 0,
            agravity = 0,
            vx = 200,
            vy = 0,
            acceleration = 2,
            xs = 0,
            ys = 0
        },
        sat2 = {
            x = 0,
            y = -350,
            radius = 5,
            mass = 10,
            angle = 0,
            fgravity = 0,
            agravity = 0,
            vx = 180,
            vy = 0,
            acceleration = 2,
            xs = 0,
            ys = 0
        }
    }
    return map, camera, visuals, objects, cursor
end

return world