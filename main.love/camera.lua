local lg = love.graphics

local function checkType(x, typename, name)
    assert(
        type(x) == typename,
        "Expected "..name.." (type = "..type(x)..") to be a "..typename.."."
    )
    return x
end

local function unpackCamera(t)
    local sx, sy, sw, sh
    if t.getWindow then
        sx, sy, sw, sh = t:getWindow()
    else
        sx, sy, sw, sh =
            t.sx or 0,
            t.sy or 0,
            t.sw or lg.getWidth(),
            t.sh or lg.getHeight()
    end
    return
        t.x or 0,
        t.y or 0,
        t.scale or t.zoom or 1,
        t.angle or t.rot or 0,
        sx, sy, sw, sh
end

local function visible(camera)
    camera = checkType(camera or EMPTY, "table", "camera")
    local camx, camy, zoom, angle, sx, sy, sw, sh = unpackCamera(camera)
    local w, h = sw / zoom, sh / zoom
    if angle ~= 0 then
        local sin, cos = math.abs(math.sin(angle)), math.abs(math.cos(angle))
        w, h = cos * w + sin * h, sin * w + cos * h
    end
    return camx - w * 0.5, camy - h * 0.5, w, h
end

local function toWorld(camera, screenx, screeny)
    checkType(screenx, "number", "screenx")
    checkType(screeny, "number", "screeny")
    camera = checkType(camera or EMPTY, "table", "camera")
    local camx, camy, zoom, angle, sx, sy, sw, sh = unpackCamera(camera)
    local sin, cos = math.sin(angle), math.cos(angle)
    local x, y = (screenx - sw/2 - sx) / zoom, (screeny - sh/2 - sy) / zoom
    x, y = cos * x - sin * y, sin * x + cos * y
    return x + camx, y + camy
end

local function toScreen(camera, worldx, worldy)
    checkType(worldx, "number", "worldx")
    checkType(worldy, "number", "worldy")
    camera = checkType(camera or EMPTY, "table", "camera")
    local camx, camy, zoom, angle, sx, sy, sw, sh = unpackCamera(camera)
    local sin, cos = math.sin(angle), math.cos(angle)
    local x, y = worldx, worldy
    x, y = cos * x + sin * y, -sin * x + cos * y
    return zoom * x + sx, zoom * y + sy
end

local function push(camera)
    camera = checkType(camera or EMPTY, "table", "camera")
    local camx, camy, zoom, angle, sx, sy, sw, sh = unpackCamera(camera)
    lg.push()
    lg.scale(zoom)
    lg.translate((sw / 2 + sx) / zoom, (sh / 2 + sy) / zoom)
    lg.rotate(-angle)
    lg.translate(-camx, -camy)
end

local function drawUI(camera, objects)
    local i = 0
    local dist = 15
    love.graphics.print("Zoom: "..settings.zoom, 0, i)
    i = i + dist
    love.graphics.print("Cursor.sx:"..cursor.sx, 0, i)
    i = i + dist
    love.graphics.print("Cursor.sy:"..cursor.sy, 0, i)
    i = i + dist
    love.graphics.print("Cursor.wx:"..cursor.x, 0, i)
    i = i + dist
    love.graphics.print("Cursor.wy:"..cursor.y, 0, i)
    i = i + dist
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 0, i)
    i = i + dist
    love.graphics.print("All objects: "..state.objectsAmount, 0, i)
    i = i + dist
    if FOCUS ~= nil then
        love.graphics.print("Object ID: "..FOCUS.id, 0, i)
        i = i + dist
        for key, value in pairs(FOCUS) do
            if key ~= "image" and key ~= "tracks" then
                --love.graphics.print(key..": "..value, 0, i)
                i = i + dist
            end
        end
    end
end

local function drawObjects(camera, objects)
    for _, value in pairs(objects) do
        love.graphics.setColor(value.color)
        love.graphics.circle("fill", value.xs, value.ys, value.radius * settings.zoom)
        love.graphics.setColor(1, 1, 1)
        --love.graphics.draw(value.image, value.xs, value.ys, value.angle, settings.zoom, settings.zoom, value.image:getWidth() / 2, value.image:getHeight() / 2)
        love.graphics.line(value.xs, value.ys, value.xs + value.vx, value.ys + value.vy)
    end
end

local cameraIndex = {
    toWorld = function (self, x, y) return toWorld(self.camera, x, y) end,
    toScreen = function (self, x, y) return toScreen(self.camera, x, y) end,
    visible = function (self) return visible(self.camera) end,
    push = function (self) return push(self.camera) end,
    drawUI = function (self, objects) return drawUI(self.camera, objects) end,
    drawObjects = function (self, objects) return drawObjects(self.camera, objects) end
}

local cameraMt = {
    __index = cameraIndex
}

local function init(camera)
    camera = checkType(camera or {}, "table", "camera")
    return setmetatable({
        camera = camera,
    }, cameraMt)
end

return {
    toWorld = toWorld,
    toScreen = toScreen,
    visible = visible,
    init = init,
    push = push,
    drawUI = drawUI,
    drawObjects = drawObjects
}
