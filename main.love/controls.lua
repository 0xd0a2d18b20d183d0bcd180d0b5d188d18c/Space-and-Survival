local camera = require "camera"
local saves = require "saves"
local tempx0, tempy0

local controls = {}

function cameraControls()
    if FOCUS == nil then
        if love.keyboard.isDown('w') then
            settings.y = settings.y - (10 / settings.zoom)
        end
        if love.keyboard.isDown('a') then
            settings.x = settings.x - (10 / settings.zoom)
        end
        if love.keyboard.isDown('s') then
            settings.y = settings.y + (10 / settings.zoom)
        end
        if love.keyboard.isDown('d') then
            settings.x = settings.x + (10 / settings.zoom)
        end
    end
end

function controls(object, dt)
    if love.keyboard.isDown('w') then
        applyAcceleration(object, object.angle, object.acceleration, dt)
    end
    if love.keyboard.isDown('s') then
        applyAcceleration(object, object.angle, -object.acceleration, dt)
    end
    if love.keyboard.isDown('a') then
        object.va = object.va - 0.05
    end
    if love.keyboard.isDown('d') then
        object.va = object.va + 0.05
    end
end

local function zoomOut()
    settings.zoom = settings.zoom - 0.05
    if settings.zoom < 0.2 then
        settings.zoom = math.abs(settings.zoom - 0.001)
    end
    if settings.zoom < 0.02 then
        settings.zoom = math.abs(settings.zoom - 0.0001)
    end
end

local function zoomIn()
    if settings.zoom > 0.2 then
        settings.zoom = math.abs(settings.zoom + 0.05)
    end
    if settings.zoom < 0.2 then
        settings.zoom = math.abs(settings.zoom + 0.01)
    end
    if settings.zoom < 0.02 then
        settings.zoom = math.abs(settings.zoom + 0.001)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" then
        if state.game == "game" then
            state.game = "pause"
        elseif state.game == "pause" then
            state.game = "game"
        end
    end
    if key == "tab" then
        if objects == nil then
            return
        end
        local error = 0
        if FOCUS ~= nil and objects[FOCUS.id] ~= nil then
            local _, value = next(objects, FOCUS.id)
            objects[FOCUS.id].focus = 0
            objects[FOCUS.id].controlled = 0
            if value ~= nil then
                value.focus = 1
                if value.underControl == 1 then
                    value.controlled = 1
                end
                return
            else
                for key, _ in pairs(objects) do
                    objects[key].focus = 1
                    if objects[key].underControl == 1 then
                        objects[key].controlled = 1
                    end
                    return
                end
            end
            error = 1
        end
        if error ~= 1 then
            for key, _ in pairs(objects) do
                objects[key].focus = 1
                if objects[key].underControl == 1 then
                    objects[key].controlled = 1
                end
                return
            end
        end
    end
    if key == "delete" then
        if FOCUS ~= nil then
            objects[FOCUS.id] = nil
            FOCUS = nil
        end
    end
    if key == "escape" then
        if state.game == "game" then
            state.game = "mainMenu"
        elseif state.game == "mainMenu" then
            state.game = "game"
        elseif state.game == "pause" then
            state.game = "mainMenu"
        end
    end
    if key == "v" then
        for _, value in pairs(objects) do
            if value.focus == 1 then
                FOCUS.focus = 0
                FOCUS = nil
            end
        end
    end
    if key == "y" then
        if FOCUS ~= nil then
            if FOCUS.isTracksVisible == 1 then
                FOCUS.isTracksVisible = 0
            else
                FOCUS.isTracksVisible = 1
            end
        end
    end
    if key == "r" then
        for key, value in pairs(objects) do
            value.vx = value.vx * -1
            value.vy = value.vy * -1
            value.va = value.va * -1
        end
    end
    if key == "1" then
        state.speed = 0
    end
    if key == "2" then
        state.speed = 1
    end
    if key == "3" then
        state.speed = 2
    end
    if key == "4" then
        state.speed = 3
    end
    if key == "5" then
        state.speed = 4
    end
    if key == "6" then
        state.speed = 5
    end
    if key == "7" then
        state.speed = 6
    end
    if key == "8" then
        state.speed = 7
    end
    if key == "9" then
        state.speed = 8
    end
    if key == "0" then
        state.speed = 9
    end
end

function love.wheelmoved(x, y)
    if y > 0 then
        zoomIn()
    elseif y < 0 then
        zoomOut()
    end
end

function love.mousepressed(x, y, button, istouch)
    tempx0, tempy0 = camera.toWorld(settings, x, y)
    local tempy = settings.sh - 350
    local distR = 25
    local distT = 5
    -- Continue
    if state.game == "mainMenu" and x >= 110 and x <= 220 then
        if y >= tempy and y <= tempy + distR + distT then
            state.game = "game"
        end
    end
    tempy = tempy + distT + distR
    -- New Game
    if state.game == "mainMenu" and x >= 110 and x <= 220 then
        if y >= tempy and y <= tempy + distR then
            objects = nil
            objects = {}
            state.game = "game"
        end
    end
    tempy = tempy + distT + distR
    -- Save
    if state.game == "mainMenu" and x >= 110 and x <= 220 then
        if y >= tempy and y <= tempy + distR then
            -- state.game = "save"
            table.save(objects, "temp")
            state.game = "game"
        end
    end
    tempy = tempy + distT + distR
    -- Load
    if state.game == "mainMenu" and x >= 110 and x <= 220 then
        if y >= tempy and y <= tempy + distR then
            -- state.game = "load"
            objects = table.load("temp")
            for _, value in pairs(objects) do
                if value.type == "sat" then
                    value.image = love.graphics.newImage("assets/sat.png")
                end
                if value.type == "moon" then
                    value.image = love.graphics.newImage("assets/moon.png")
                end
            end
            state.game = "game"
        end
    end
    tempy = tempy + distT + distR
    -- Settings
    if state.game == "mainMenu" and x >= 110 and x <= 220 then
        if y >= tempy and y <= tempy + distR then
            -- state.game = "settings"
        end
    end
    tempy = tempy + distT + distR
    -- Quite
    if state.game == "mainMenu" and x >= 110 and x <= 220 then
        if y >= tempy and y <= tempy + distR then
            love.event.quit()
        end
    end
end

function love.mousereleased(x, y, button)
    if state.game == "game" and love.keyboard.isDown('lctrl') then
        local tempx1, tempy1 = camera.toWorld(settings, x, y)
        if button == 1 then
            table.insert(objects, {
                x = tempx0 / settings.zoom,
                y = tempy0 / settings.zoom,
                radius = 12,
                mass = 10,
                type = "sat",
                angle = 0,
                underControl = 1,
                controlled = 1,
                vx = tempx1 - tempx0,
                vy = tempy1 - tempy0,
                va = 0,
                acceleration = 100,
                rotation = math.pi,
                image = love.graphics.newImage("assets/sat.png"),
                xs = 0,
                ys = 0,
                isTracksVisible = 0,
                tracks = {
                    {
                        x = tempx0 / settings.zoom,
                        y = tempy0 / settings.zoom
                    }
                },
                color = {0, 0, 1},
                focus = 0
            })
        end
        if button == 2 then
            table.insert(objects, {
                x = tempx0 / settings.zoom,
                y = tempy0 / settings.zoom,
                radius = 210,
                mass = 7 * 10 ^ 11,
                -- mass = 1,
                type = "moon",
                angle = 0,
                underControl = 0,
                controlled = 0,
                vx = tempx1 - tempx0,
                vy = tempy1 - tempy0,
                va = 0.02,
                acceleration = 0,
                rotation = math.pi,
                image = love.graphics.newImage("assets/moon.png"),
                xs = 0,
                ys = 0,
                isTracksVisible = 0,
                tracks = {
                    {
                        x = tempx0 / settings.zoom,
                        y = tempy0 / settings.zoom
                    }
                },
                color = {0, 1, 0},
                focus = 0
            })
        end
    end
end

return controls
