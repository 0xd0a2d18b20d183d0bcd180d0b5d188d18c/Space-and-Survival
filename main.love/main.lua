if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local camera = require "camera"
local controls = require "controls"
local geometry = require "geometry"
local physics = require "physics"
local world = require "world"
FOCUS = nil
lines = {}
range = 100000

function love.load()
    map, settings, objects, cursor, state = initWorld()
end

function love.update(dt)
    if state.game == "game" or state.game == "pause" then
        for key, value in pairs(objects) do
            if value.focus == 1 then
                FOCUS = value
                FOCUS.id = key
                settings.x = FOCUS.x * settings.zoom
                settings.y = FOCUS.y * settings.zoom
            end
            value.xs, value.ys = camera.toScreen(settings, value.x, value.y)
        end
        cameraControls()
    end
    if state.game == "game" then
        for i = 0, state.speed, 1 do
            for key1, object1 in pairs(objects) do
                for key2, object2 in pairs(objects) do
                    if object1 ~= object2 then
                        local distance = calcDistance(object1, object2)
                        applyAcceleration(object1, calcAngle(object2, object1), calcAcceleration(calcGravityForce(object1, object2), object1.mass), dt)
                        if checkCollision(object1, object2, distance) then
                            destroyObjects(object1, key1, object2, key2)
                        end
                        if math.abs(object1.x - object2.x) < range and math.abs(object1.y - object2.y) < range and object1.type == "sat" and object2.type == "sat" then
                            local err = 1
                            local col = 0
                            for keyline, line in pairs(lines) do
                                if line.id1 == key1 and line.id2 == key2 then
                                    for key3, object3 in pairs(objects) do
                                        if key3 ~= key1 and key3 ~= key2 and object3.type == "moon" then
                                            if object3.x - object3.radius < math.max(object1.x, object2.x) and object3.x + object3.radius > math.min(object1.x, object2.x) then
                                                if object3.y - object3.radius < math.max(object1.y, object2.y) and object3.y + object3.radius > math.min(object1.y, object2.y) then
                                                    local dx = math.abs(object1.x - object2.x)
                                                    local dy = math.abs(object1.y - object2.y)
                                                    local k = dx / dy
                                                    if math.deg(math.atan2(object1.y - object2.y, object1.x - object2.x)) >= 0 and math.deg(math.atan2(object1.y - object2.y, object1.x - object2.x)) <= 90 then
                                                        local tempx1 = object3.x
                                                        local tempy1
                                                        if object1.y > object2.y then
                                                            tempy1 = object1.y - (math.abs(object1.x - object3.x) / k)
                                                        else
                                                            tempy1 = object1.y - (math.abs(object2.x - object3.x) / k)
                                                        end
                                                        local tempx2
                                                        local tempy2 = object3.y
                                                        if object1.x > object2.x then
                                                            tempx2 = object1.x - (math.abs(object1.y - object3.y) * k)
                                                        else
                                                            tempx2 = object1.x - (math.abs(object2.y - object3.y) * k)
                                                        end
                                                        local tempx3, tempy3 = object3.x, object3.y
                                                        local hypo = math.sqrt((math.abs(tempx1 - tempx2) ^ 2) + (math.abs(tempy1 - tempy2) ^ 2))
                                                        local angle = (90 * (tempx2 - tempx3)) / hypo
                                                        local leg = ((tempy3 - tempy1) / 90) * math.abs(angle)
                                                        if object3.radius > math.abs(leg) then
                                                            col = 1
                                                        end
                                                    else
                                                        local tempx1 = object3.x
                                                        local tempy1
                                                        if object1.y > object2.y then
                                                            tempy1 = object1.y - (math.abs(object1.x - object3.x) / k)
                                                        else
                                                            tempy1 = object1.y - (math.abs(object2.x - object3.x) / k)
                                                        end
                                                        local tempx2
                                                        local tempy2 = object3.y
                                                        if object1.x > object2.x then
                                                            tempx2 = object1.x - (math.abs(object1.y - object3.y) * k)
                                                        else
                                                            tempx2 = object2.x - (math.abs(object2.y - object3.y) * k)
                                                        end
                                                        local tempx3, tempy3 = object3.x, object3.y
                                                        local hypo = math.sqrt((math.abs(tempx1 - tempx2) ^ 2) + (math.abs(tempy1 - tempy2) ^ 2))
                                                        local angle = (90 * (tempx2 - tempx3)) / hypo
                                                        local leg = ((tempy3 - tempy1) / 90) * math.abs(angle)
                                                        if object3.radius > math.abs(leg) then
                                                            col = 1
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    if col == 0 then
                                        line.x1 = object1.x
                                        line.x2 = object2.x
                                        line.y1 = object1.y
                                        line.y2 = object2.y
                                    end
                                    if col == 1 then
                                        lines[keyline] = nil
                                    end
                                    err = 0
                                end
                            end
                            -- local linescounter = 0
                            -- for _, _ in pairs(lines) do linescounter = linescounter + 1 end
                            -- print(linescounter)

                            if err == 1 then
                                for key3, object3 in pairs(objects) do
                                    if key3 ~= key1 and key3 ~= key2 and object3.type == "moon" then
                                        if object3.x - object3.radius < math.max(object1.x, object2.x) and object3.x + object3.radius > math.min(object1.x, object2.x) then
                                            if object3.y - object3.radius < math.max(object1.y, object2.y) and object3.y + object3.radius > math.min(object1.y, object2.y) then
                                                local dx = math.abs(object1.x - object2.x)
                                                local dy = math.abs(object1.y - object2.y)
                                                local k = dx / dy
                                                if math.deg(math.atan2(object1.y - object2.y, object1.x - object2.x)) >= 0 and math.deg(math.atan2(object1.y - object2.y, object1.x - object2.x)) <= 90 then
                                                    local tempx1 = object3.x
                                                    local tempy1
                                                    if object1.y > object2.y then
                                                        tempy1 = object1.y - (math.abs(object1.x - object3.x) / k)
                                                    else
                                                        tempy1 = object1.y - (math.abs(object2.x - object3.x) / k)
                                                    end
                                                    local tempx2
                                                    local tempy2 = object3.y
                                                    if object1.x > object2.x then
                                                        tempx2 = object1.x - (math.abs(object1.y - object3.y) * k)
                                                    else
                                                        tempx2 = object1.x - (math.abs(object2.y - object3.y) * k)
                                                    end
                                                    local tempx3, tempy3 = object3.x, object3.y
                                                    local hypo = math.sqrt((math.abs(tempx1 - tempx2) ^ 2) + (math.abs(tempy1 - tempy2) ^ 2))
                                                    local angle = (90 * (tempx2 - tempx3)) / hypo
                                                    local leg = ((tempy3 - tempy1) / 90) * math.abs(angle)
                                                    if object3.radius > math.abs(leg) then
                                                        col = 1
                                                    end
                                                else
                                                    local tempx1 = object3.x
                                                    local tempy1
                                                    if object1.y > object2.y then
                                                        tempy1 = object1.y - (math.abs(object1.x - object3.x) / k)
                                                    else
                                                        tempy1 = object1.y - (math.abs(object2.x - object3.x) / k)
                                                    end
                                                    local tempx2
                                                    local tempy2 = object3.y
                                                    if object1.x > object2.x then
                                                        tempx2 = object1.x - (math.abs(object1.y - object3.y) * k)
                                                    else
                                                        tempx2 = object2.x - (math.abs(object2.y - object3.y) * k)
                                                    end
                                                    local tempx3, tempy3 = object3.x, object3.y
                                                    local hypo = math.sqrt((math.abs(tempx1 - tempx2) ^ 2) + (math.abs(tempy1 - tempy2) ^ 2))
                                                    local angle = (90 * (tempx2 - tempx3)) / hypo
                                                    local leg = ((tempy3 - tempy1) / 90) * math.abs(angle)
                                                    if object3.radius > math.abs(leg) then
                                                        col = 1
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    for _, line in pairs(lines) do
                                        if (line.id1 == key1 and line.id2 == key2) or (line.id2 == key1 and line.id1 == key2) then
                                            col = 1
                                        end
                                    end
                                    if col == 0 then
                                        if math.deg(math.atan2(object1.y - object2.y, object1.x - object2.x)) >= 0 and math.deg(math.atan2(object1.y - object2.y, object1.x - object2.x)) <= 180 then
                                            table.insert(lines, {
                                                id1 = key1,
                                                id2 = key2,
                                                x1 = object1.x,
                                                x2 = object2.x,
                                                y1 = object1.y,
                                                y2 = object2.y
                                            })
                                        end
                                    end
                                end
                            end
                        else
                            for key, _ in pairs(lines) do
                                if lines[key].id1 == key1 and lines[key].id2 == key2 then
                                    lines[key] = nil
                                end
                            end
                        end
                    end
                end
                applyAngularVelocity(object1, dt)
                updatePosition(object1, dt)
                state.every.fps20 = state.every.fps20 + 1
                if state.every.fps20 == 20 then
                    if objects[key1] ~= nil then
                        if objects[key1].x ~= objects[key1].tracks[#objects[key1].tracks].x or objects[key1].y ~= objects[key1].tracks[#objects[key1].tracks].y then
                            table.insert(objects[key1].tracks, {
                                x = objects[key1].x,
                                y = objects[key1].y
                            })
                        end
                        state.objectsAmount = 0
                        for _, _ in pairs(objects) do state.objectsAmount = state.objectsAmount + 1 end
                    end
                    for key, line in pairs(lines) do
                        if objects[line.id1] == nil or objects[line.id2] == nil then
                            lines[key] = nil
                        end
                    end
                    state.every.fps20 = 0
                end
            end
            if FOCUS ~= nil then
                controls(FOCUS, dt)
            end
        end
    end
    updateCursorPosition()
end

function love.draw(dt)
    local cameraObject = camera.init(settings)
    cameraObject:push()
    love.graphics.pop()
    if state.game == "game" or state.game == "pause" then
        cameraObject:push()
        cameraObject.drawObjects(settings, objects)
        for key, value in pairs(objects) do
            if value.isTracksVisible == 1 then
                for _, value in pairs(value.tracks) do
                    xs, ys = camera.toScreen(settings, value.x, value.y)
                    love.graphics.circle("fill", xs, ys, 1)
                end
            end
        end
        if lines ~= nil then
            for _, value in pairs(lines) do
                xs1, ys1 = camera.toScreen(settings, value.x1, value.y1)
                xs2, ys2 = camera.toScreen(settings, value.x2, value.y2)
                love.graphics.line(xs1, ys1, xs2, ys2)
            end
        end
        love.graphics.pop()
        cameraObject.drawUI(settings, objects)
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
