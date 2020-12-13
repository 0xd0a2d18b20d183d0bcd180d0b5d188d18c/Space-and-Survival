local camera = require "camera"
local controls = require "controls"
local geometry = require "geometry"
local physics = require "physics"
local world = require "world"



function love.load()
    map, settings, objects, cursor, state = initWorld()
end

function love.update(dt)
    if state.stop == 0 then
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
                        if value1.type == "sat" and value2.type == "sat" then
                            objects[key1] = nil
                            objects[key2] = nil
                        end
                        if value1.type == "sat" and value2.type == "planet" then
                            objects[key1] = nil
                        end
                        if value1.type == "planet" and value2.type == "planet" then
                            objects[key1] = nil
                            objects[key2] = nil
                        end
                    end
                end
            end
            applyAngularVelocity(value1, dt)
            updatePosition(value1, dt)
            value1.xs, value1.ys = camera.toScreen(settings, value1.x, value1.y)
        end
        for key, value in pairs(objects) do
            if value.controlled == 1 then
                controls(value, dt)
            end
        end
    end
    updateCursorPosition()
    cameraControls()
end

function love.draw(dt)
    local camera = camera.init(settings)
    camera:push()
    camera.drawObjects(settings, objects)
    love.graphics.pop()
    camera.drawUI(settings, objects)
end
