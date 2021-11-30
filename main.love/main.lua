local camera = require "camera"
local controls = require "controls"
local geometry = require "geometry"
local physics = require "physics"
local world = require "world"
SPEED = 0

function love.load()
    map, settings, objects, cursor, state = initWorld()
end

function love.update(dt)
    if state.game == "game" then
        for i = 0, SPEED, 1 do
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
                if value.focus == 1 then
                    controls(value, dt)
                    settings.x = value.x * settings.zoom
                    settings.y = value.y * settings.zoom
                end
            end
        end
    end
    if state.game == "game" or state.game == "pause" then
        for key, value in pairs(objects) do
            if value.focus == 1 then
                settings.x = value.x * settings.zoom
                settings.y = value.y * settings.zoom
            end
        end
        cameraControls()
    end
    updateCursorPosition()
end

function love.draw(dt)
    local camera = camera.init(settings)
    camera:push()
    love.graphics.pop()
    if state.game == "game" or state.game == "pause" then
        camera:push()
        camera.drawObjects(settings, objects)
        love.graphics.pop()
        camera.drawUI(settings, objects)
    end
    if state.game == "mainMenu" then
        local x = 110
        local y = settings.sh - 350
        local distR = 30
        local distT = 5
        love.graphics.rectangle("line", x, y, 100, 25)
        love.graphics.print("Continue", x + 10, y + distT)
        y = y + distR
        love.graphics.rectangle("line", x, y, 100, 25)
        love.graphics.print("New Game", x + 10, y + distT)
        y = y + distR
        love.graphics.rectangle("line", x, y, 100, 25)
        love.graphics.print("Save", x + 10, y + distT)
        y = y + distR
        love.graphics.rectangle("line", x, y, 100, 25)
        love.graphics.print("Load", x + 10, y + distT)
        y = y + distR
        love.graphics.rectangle("line", x, y, 100, 25)
        love.graphics.print("Settings", x + 10, y + distT)
        y = y + distR
        love.graphics.rectangle("line", x, y, 100, 25)
        love.graphics.print("Quit", x + 10, y + distT)
        y = y + distR
    end
    if state.game == "pause" then
        love.graphics.print("PAUSE", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    end
end
