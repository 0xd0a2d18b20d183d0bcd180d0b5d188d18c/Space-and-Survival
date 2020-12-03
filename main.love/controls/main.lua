local controls = {}

function cameraControls()
    if love.keyboard.isDown('up') then
        camera.y = camera.y - (10 / camera.zoom)
    end
    if love.keyboard.isDown('down') then
        camera.y = camera.y + (10 / camera.zoom)
    end
    if love.keyboard.isDown('left') then
        camera.x = camera.x - (10 / camera.zoom)
    end
    if love.keyboard.isDown('right') then
        camera.x = camera.x + (10 / camera.zoom)
    end
end

function control(object, angle)
    if love.keyboard.isDown('x') then
        applyAcceleration(object, angle - 1.5708, object.acceleration, 1)
    end
    if love.keyboard.isDown('z') then
        applyAcceleration(object, angle + 1.5708, object.acceleration, 1)
    end
    if love.keyboard.isDown('c') then
        applyAcceleration(object, angle + 3.1416, object.acceleration * 40, 1)
    end
end

function zoomOut()
    camera.zoom = camera.zoom - 0.05
    if camera.zoom < 0.2 then
        camera.zoom = math.abs(camera.zoom - 0.01)
    end
    if camera.zoom < 0.02 then
        camera.zoom = math.abs(camera.zoom - 0.001)
    end
end

function zoomIn()
    if camera.zoom < 0.02 then
        camera.zoom = math.abs(camera.zoom + 0.001)
    end
    if camera.zoom < 0.2 then
        camera.zoom = math.abs(camera.zoom + 0.01)
    end
    if camera.zoom > 0.2 then
        camera.zoom = math.abs(camera.zoom + 0.05)
    end
end

function love.keypressed(key, scancode, isrepeat)
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
