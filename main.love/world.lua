local json = require "json"

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
    local settings = {
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
            y = -400,
            radius = 5,
            mass = 10,
            angle = 0,
            controlled = 1,
            vx = 500,
            vy = 0,
            acceleration = 10,
            rotation = math.pi,
            image = love.graphics.newImage("assets/rocket.png"),
            xs = 0,
            ys = 0
        },
        moon = {
            x = 0,
            y = 0,
            radius = 210,
            mass = 6 * 10 ^ 11,
            angle = 0,
            controlled = 0,
            vx = 0,
            vy = 0,
            acceleration = 0,
            rotation = math.pi,
            image = love.graphics.newImage("assets/moon.png"),
            xs = 0,
            ys = 0
        },

    }
    return map, settings, objects, cursor
end

return world
