local camera = require "camera"
local world = require "world"

local debug

function debugInformation()
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

return debug
