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
    if t.getWindow then -- assume t is a gamera camera
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
    local x, y = worldx - camx, worldy - camy
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

local cameraIndex = {
    toWorld = function (self, x, y) return toWorld(self.camera, x, y) end,
    toScreen = function (self, x, y) return toScreen(self.camera, x, y) end,
    visible = function (self) return visible(self.camera) end,
    push = function (self) return push(self.camera) end
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
    push = push
}
