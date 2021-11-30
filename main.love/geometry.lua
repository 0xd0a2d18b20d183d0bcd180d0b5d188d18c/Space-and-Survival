local camera = require "camera"

local geometry = {}

function calcDistance(object1, object2)
    return math.sqrt(math.abs(object1.x - object2.x) ^ 2 + math.abs(object1.y - object2.y) ^ 2)
end

function calcAngle(object1, object2)
    return math.atan2(object1.y - object2.y, object1.x - object2.x)
end

function updatePosition(object, dt)
    object.x = object.x + object.vx * dt
    object.y = object.y + object.vy * dt
end

function updateCursorPosition()
    cursor.sx, cursor.sy = love.mouse.getPosition()
    cursor.x, cursor.y = camera.toWorld(settings, cursor.sx, cursor.sy)
end

return geometry
