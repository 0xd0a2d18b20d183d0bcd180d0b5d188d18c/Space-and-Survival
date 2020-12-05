local camera = require "../camera/main"
local world = require "../world/main"

local debug

function debugInformation(stop)
    local i = 0
    local dist = 15
    love.graphics.print("Stop:"..stop, 0, i)
    i = i + dist
    love.graphics.print("Cursor.sx:"..cursor.sx, 0, i)
    i = i + dist
    love.graphics.print("Cursor.sy:"..cursor.sy, 0, i)
    i = i + dist
    love.graphics.print("Cursor.wx:"..cursor.x, 0, i)
    i = i + dist
    love.graphics.print("Cursor.wy:"..cursor.y, 0, i)
    i = i + dist
    for key, value in pairs(objects.sat2) do
        love.graphics.print(key..": "..value, 0, i)
        i = i + dist
    end
    --[[love.graphics.print("Sun:", 0, i)
    i = i + dist
    for key, value in pairs(objects.sun) do
        love.graphics.print(key..": "..value, 0, i)
        i = i + dist
    end
    i = i + dist
    love.graphics.print("Mercury:", 0, i)
    i = i + dist
    for key, value in pairs(objects.mercury) do
        love.graphics.print(key..": "..value, 0, i)
        i = i + dist
    end
    i = i + dist
    love.graphics.print("Venus:", 0, i)
    i = i + dist
    for key, value in pairs(objects.venus) do
        love.graphics.print(key..": "..value, 0, i)
        i = i + dist
    end
    i = i + dist
    love.graphics.print("Earth:", 0, i)
    i = i + dist
    for key, value in pairs(objects.venus) do
        love.graphics.print(key..": "..value, 0, i)
        i = i + dist
    end
    i = i + dist
    love.graphics.print("Mars:", 0, i)
    i = i + dist
    for key, value in pairs(objects.venus) do
        love.graphics.print(key..": "..value, 0, i)
        i = i + dist
    end
    --]]
end

function cursorCoordinates(settings)
    cursor.sx, cursor.sy = love.mouse.getPosition( )
    cursor.x, cursor.y = camera.toWorld(settings, cursor.sx, cursor.sy)
end

return debug
