local editgrid = require "camera/editgrid"
local physics = require "physics/main"
local geometry = require "geometry/main"
local controls = require "controls/main"
local debug = require "debug/main"
local world = require "world/main"

function love.load()
    map, camera, visuals, objects, cursor = initWorld()
end

function love.update(dt)
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
        value1.xs, value1.ys = editgrid.toScreen(camera, value1.x, value1.y)
    end
    cursorCoordinates(camera)
    cameraControls()
    for key, value in pairs(objects) do
        if value.controlled == 1 then
            controls(value)
        end
    end
end

function love.draw(dt)
    local grid = editgrid.grid(camera, visuals)
    --grid:draw()
    debugInformation()
    grid:push()
    for key, value in pairs(objects) do
        love.graphics.circle("line", value.xs, value.ys, value.radius * camera.zoom)
    end
    love.graphics.pop()
end
