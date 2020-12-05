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
        planet = {
            x = 0,
            y = 0,
            radius = 75,
            mass = 6 * 10 ^ 11,
            angle = 0,
            fgravity = 0,
            agravity = 0,
            vx = 0,
            vy = 150,
            acceleration = 0,
            xs = 0,
            ys = 0
        },    
        sat = {
            x = 0,
            y = -200,
            radius = 5,
            mass = 10,
            angle = 0,
            fgravity = 0,
            agravity = 0,
            vx = 250,
            vy = 0,
            acceleration = 2,
            xs = 0,
            ys = 0
        },
        sat2 = {
            x = 0,
            y = 340,
            radius = 5,
            mass = 10,
            angle = 0,
            fgravity = 0,
            agravity = 0,
            vx = 0,
            vy = 400,
            acceleration = 2,
            xs = 0,
            ys = 0
        },
        sat3 = {
            x = 0,
            y = 310,
            radius = 5,
            mass = 10,
            angle = 0,
            fgravity = 0,
            agravity = 0,
            vx = 0,
            vy = -300,
            acceleration = 2,
            xs = 0,
            ys = 0
        },
        sat4 = {
            x = 0,
            y = 300,
            radius = 5,
            mass = 10,
            angle = 0,
            fgravity = 0,
            agravity = 0,
            vx = -350,
            vy = 0,
            acceleration = 2,
            xs = 0,
            ys = 0
        },
        planet2 = {
            x = 1000,
            y = 1000,
            radius = 75,
            mass = 6 * 10 ^ 11,
            angle = 0,
            fgravity = 0,
            agravity = 0,
            vx = 0,
            vy = -150       ,
            acceleration = 2,
            xs = 0,
            ys = 0
        }
    }
    return map, camera, objects, cursor
end

return world
