local camera = require "camera/main"
local physics = require "physics/main"
local geometry = require "geometry/main"
local controls = require "controls/main"
local debug = require "debug/main"
local world = require "world/main"
local json = require "json/main"

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
                    if checkCollision(value1, value2, distance) then
                        --[[
                        value1.vx = value1.vx / 10
                        value1.vy = value1.vy / 10
                        value2.vx = value2.vx / 10
                        value2.vy = value2.vy / 10
                        --]]
                    end
                end
            end
            updatePosition(value1, dt)
            value1.xs, value1.ys = camera.toScreen(settings, value1.x, value1.y)
        end
        for key, value in pairs(objects) do
            if value.controlled == 1 then
                controls(value)
            end
        end
    end
    cursorCoordinates(settings)
    cameraControls()
end

function love.draw(dt)
    local camera = camera.init(settings)
    debugInformation(stop)
    camera:push()
    for key, value in pairs(objects) do
        love.graphics.circle("line", value.xs, value.ys, value.radius * settings.zoom)
    end
    love.graphics.pop()
end
