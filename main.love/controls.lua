local controls = {}

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
    if settings.zoom < 0.02 then
        settings.zoom = math.abs(settings.zoom + 0.001)
    end
    if settings.zoom < 0.2 then
        settings.zoom = math.abs(settings.zoom + 0.01)
    end
    if settings.zoom > 0.2 then
        settings.zoom = math.abs(settings.zoom + 0.05)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" then
        if stop == 0 then
            stop = 1
        elseif stop == 1 then
            stop = 0
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

return controls
