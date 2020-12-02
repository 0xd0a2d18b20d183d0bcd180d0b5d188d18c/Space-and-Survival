local editgrid = require "editgrid"

function calcGravityForce(object1, object2, distance)
    if checkCollisionInvert(object1, object2, distance) then
        return G * ((object2.mass * object1.mass) / (math.abs(object1.x - object2.x) ^ 2 + math.abs(object1.y - object2.y) ^ 2))
    else
        return G * ((object2.mass * object1.mass) / (object2.radius + object1.radius) ^ 2)
    end
end

function calcAcceleration(f, m)
    return f / m
end

function checkCollisionInvert(object1, object2, distance)
    if distance < (object1.radius + object2.radius) then
        return false
    end
    return true
end

function calcDistance(object1, object2)
    return math.sqrt(math.abs(object1.x - object2.x) ^ 2 + math.abs(object1.y - object2.y) ^ 2)
end

function calcAngle(object1, object2)
    return math.atan2(object1.y - object2.y, object1.x - object2.x)
end

function applyAcceleration(object, angle, a, dt)
    object.vx = object.vx + math.cos(angle) * a * dt
    object.vy = object.vy + math.sin(angle) * a * dt
end

function updatePosition(object, dt)
    object.x = object.x + object.vx * dt
    object.y = object.y + object.vy * dt
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
    if love.keyboard.isDown('up') then
        camera.y = camera.y - 10
    end
    if love.keyboard.isDown('down') then
        camera.y = camera.y + 10
    end
    if love.keyboard.isDown('left') then
        camera.x = camera.x - 10
    end
    if love.keyboard.isDown('right') then
        camera.x = camera.x + 10
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
    end
    if key == "kp-" then
        camera.zoom = camera.zoom - 0.05
    end 
 end

function love.wheelmoved(x, y)
    if y > 0 then
            camera.zoom = camera.zoom + 0.05
    elseif y < 0 then
        camera.zoom = math.abs(camera.zoom - 0.05)
        if camera.zoom < 0.2 then
            camera.zoom = math.abs(camera.zoom - 0.01)
        end
        if camera.zoom < 0.02 then
            camera.zoom = math.abs(camera.zoom - 0.001)
        end
    end
end

function drawUI(vx, vy, vw, vh)
    love.graphics.print('Sat.x: '..sat.x)
    love.graphics.print('Sat.y: '..sat.y, 0, 15)
    love.graphics.print('Sat.vy: '..sat.vy, 0, 30)
    love.graphics.print('Sat.vx: '..sat.vx, 0, 45)
    love.graphics.print('Scale: '..camera.zoom, 0, 60)
    love.graphics.print('Mx: '..mx, 0, 75)
    love.graphics.print('My: '..my, 0, 90)
    love.graphics.print('Mxw: '..mxw, 0, 105)
    love.graphics.print('Myw: '..myw, 0, 120)
    love.graphics.print('Planet.x: '..planet.x, 0, 135)
    love.graphics.print('Planet.y: '..planet.y, 0, 150)
    love.graphics.print('Planet.xscreen: '..planet.xs, 0, 165)
    love.graphics.print('Planet.yscreen: '..planet.ys, 0, 180)
end

function love.load()
    map = {
        x = 149597870700,
        y = 149597870700
    }
    
    camera = {
        x = 341,
        y = 192,
        zoom = 1,
        angle = 0,
        sx = 0,
        sy = 0,
        sw = love.graphics.getWidth(),
        sh = love.graphics.getHeight()
    }

    visuals = {
        size = 256,
        subdivisions = 4,
        color = {0, 0, 0},
        drawScale = false,
        xColor = {255, 255, 0},
        yColor = {0, 255, 255},
        fadeFactor = 0.3,
        textFadeFactor = 0.5,
        hideOrigin = true,
        interval = 100
    }

    planet = {
        x = 0,
        y = 0,
        radius = 75,
        mass = 6 * 10 ^ 11,
        v = 0,
        xs = 0,
        ys = 0
    }

    sat = {
        x = 0,
        y = -183,
        radius = 5,
        mass = 100,
        angle = 0,
        vx = 400,
        vy = 0,
        acceleration = 2,
        xs = 0,
        ys = 0
    }

    G = 0.00006
    scale = 1
    au = 149597870700
end

function love.update(dt)
    local distance = calcDistance(planet, sat)
    local angle = calcAngle(planet, sat)
    local f = calcGravityForce(planet, sat, distance)
    local a = calcAcceleration(f, sat.mass)
    local dt = love.timer.getDelta()
    applyAcceleration(sat, angle, a, dt)
    if not checkCollisionInvert(planet, sat, distance) then
        sat.vx = 0
        sat.vy = 0
    end
    control(sat, angle)
    updatePosition(sat, dt)
    mx, my = love.mouse.getPosition( )
    mxw, myw = editgrid.toWorld(camera, mx, my)
    sat.xs, sat.ys = editgrid.toScreen(camera, sat.x, sat.y)
    planet.xs, planet.ys = editgrid.toScreen(camera, planet.x, planet.y)
end

function love.draw(dt)
    local grid = editgrid.grid(camera, visuals)
    grid:draw()
    drawUI()
    grid:push()
    love.graphics.circle("fill", planet.xs, planet.ys, planet.radius * camera.zoom)
    love.graphics.circle("fill", sat.xs, sat.ys, sat.radius * camera.zoom)
    love.graphics.line(planet.xs, planet.ys, sat.xs, sat.ys)
    love.graphics.pop()
end
