local camera = require "camera"

local controls = {}

local tempx0 = 0
local tempy0 = 0

function cameraControls()
    if love.keyboard.isDown('up') then
        settings.y = settings.y - (10 / settings.zoom)
    end
    if love.keyboard.isDown('down') then
        settings.y = settings.y + (10 / settings.zoom)
    end
    if love.keyboard.isDown('left') then
        settings.x = settings.x - (10 / settings.zoom)
    end
    if love.keyboard.isDown('right') then
        settings.x = settings.x + (10 / settings.zoom)
    end
    if love.keyboard.isDown('q') then
        settings.angle = settings.angle + 0.01
    end
    if love.keyboard.isDown('e') then
        settings.angle = settings.angle - 0.01
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
        if state.stop == 0 then
            state.stop = 1
        elseif state.stop == 1 then
            state.stop = 0
        end
    end
    if key == "escape" then
       love.event.quit()
    end
    if key == "kp+" then
        zoomIn()
    end
    if key == "kp-" then
        zoomOut()
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
    if button == 1 then
        tempx0, tempy0 = camera.toWorld(settings, x, y)
    end
    if button == 2 then
        tempx0, tempy0 = camera.toWorld(settings, x, y)
    end
end

function love.mousereleased(x, y, button)
    tempx1, tempy1 = camera.toWorld(settings, x, y)
    if button == 1 then
        table.insert(objects, {
            x = tempx0 / settings.zoom,
            y = tempy0 / settings.zoom,
            radius = 12,
            mass = 10,
            type = "sat",
            angle = 0,
            controlled = 1,
            vx = tempx1 - tempx0,
            vy = tempy1 - tempy0,
            va = 0,
            acceleration = 100,
            rotation = math.pi,
            image = love.graphics.newImage("assets/sat.png"),
            xs = 0,
            ys = 0
        })
    end
    if button == 2 then
        table.insert(objects, {
            x = tempx0 / settings.zoom,
            y = tempy0 / settings.zoom,
            radius = 210,
            mass = 7 * 10 ^ 11,
            type = "planet",
            angle = 0,
            controlled = 0,
            vx = tempx1 - tempx0,
            vy = tempy1 - tempy0,
            va = 0.02,
            acceleration = 0,
            rotation = math.pi,
            image = love.graphics.newImage("assets/moon.png"),
            xs = 0,
            ys = 0
        })
    end
 end

return controls
