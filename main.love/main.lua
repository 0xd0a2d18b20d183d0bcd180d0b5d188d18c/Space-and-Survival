local camera = require "camera"
local physics = require "physics"
local geometry = require "geometry"
local controls = require "controls"
local debug = require "debug"
local world = require "world"
local json = require "json"

function love.load()
    map, settings, objects, cursor = initWorld()
    stop = 0
end

function love.update(dt)
    if stop == 0 then
        for key1, value1 in pairs(objects) do
            for key2, value2 in pairs(objects) do
                if value1 ~= value2 then
                    local distance = calcDistance(value1, value2)
                    local angle1 = calcAngle(value2, value1)
                    local angle2 = calcAngle(value1, value2)
                    local f = calcGravityForce(value1, value2, distance)
                    local acc1 = calcAcceleration(f, value1.mass)
                    local acc2 = calcAcceleration(f, value2.mass)
                    applyAcceleration(value1, angle1, acc1, dt)
                    applyAcceleration(value2, angle2, acc2, dt)
                end
            end
            updatePosition(value1, dt)
            value1.xs, value1.ys = camera.toScreen(settings, value1.x, value1.y)
        end
        for key, value in pairs(objects) do
            if value.controlled == 1 then
                controls(value, dt)
            end
        end
    end
    cursor.sx, cursor.sy = love.mouse.getPosition( )
    cursor.x, cursor.y = camera.toWorld(settings, cursor.sx, cursor.sy)
    cameraControls()
end

function love.draw(dt)
    local camera = camera.init(settings)
    --debugInformation(cursor)
    local i = 0
    local dist = 15
    love.graphics.print("Cursor.sx:"..cursor.sx, 0, i)
    i = i + dist
    love.graphics.print("Cursor.sy:"..cursor.sy, 0, i)
    i = i + dist
    love.graphics.print("Cursor.wx:"..cursor.x, 0, i)
    i = i + dist
    love.graphics.print("Cursor.wy:"..cursor.y, 0, i)
    camera:push()
    for key, value in pairs(objects) do
        love.graphics.draw(value.image, value.xs, value.ys, value.angle, settings.zoom, settings.zoom, value.image:getWidth() / 2, value.image:getHeight() / 2)
        love.graphics.line(value.xs, value.ys, value.xs + value.vx, value.ys + value.vy)
    end
    love.graphics.pop()
end
