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
                    applyAcceleration(value1, calcAngle(value2, value1), calcAcceleration(calcGravityForce(value1, value2, distance), value1.mass), dt)
                    if checkCollision(value1, value2, distance) then
                        destroyObjects(value1, key1, value2, key2)
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
    camera.drawUI(settings, objects)
    local camera = camera.init(settings)
    camera:push()
    camera.drawObjects(settings, objects)
    love.graphics.pop()
end
