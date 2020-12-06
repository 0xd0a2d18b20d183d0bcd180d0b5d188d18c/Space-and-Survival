local camera = require "../camera/main"
local world = require "../world/main"

local debug

function debugInformation(stop)
    local i = 0
    local dist = 15
    love.graphics.print("Cursor.sx:"..cursor.sx, 0, i)
    i = i + dist
    love.graphics.print("Cursor.sy:"..cursor.sy, 0, i)
    i = i + dist
    love.graphics.print("Cursor.wx:"..cursor.x, 0, i)
    i = i + dist
    love.graphics.print("Cursor.wy:"..cursor.y, 0, i)
end

function cursorCoordinates(settings)
    cursor.sx, cursor.sy = love.mouse.getPosition( )
    cursor.x, cursor.y = camera.toWorld(settings, cursor.sx, cursor.sy)
end

return debug
