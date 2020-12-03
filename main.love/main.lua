local editgrid = require "editgrid"

function calcGravityForce(object1, object2, distance)
    if checkCollision(object1, object2, distance) then
        return G * ((object2.mass * object1.mass) / (object2.radius + object1.radius) ^ 2)
    else
        return G * ((object2.mass * object1.mass) / (math.abs(object1.x - object2.x) ^ 2 + math.abs(object1.y - object2.y) ^ 2))
    end
end

function calcAcceleration(f, m)
    return f / m
end

function checkCollision(object1, object2, distance)
    if distance < (object1.radius + object2.radius) then
        return true
    end
    return false
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
    --[[local i = 0
    love.graphics.print("Sun:", 0, i)
    i = i + 15
    for key, value in pairs(objects.sun) do
        love.graphics.print(key..": "..value, 0, i)
        i = i + 15
    end
    i = i + 15
    love.graphics.print("Mercury:", 0, i)
    i = i + 15
    for key, value in pairs(objects.mercury) do
        love.graphics.print(key..": "..value, 0, i)
        i = i + 15
    end
    i = i + 15
    love.graphics.print("Venus:", 0, i)
    i = i + 15
    for key, value in pairs(objects.venus) do
        love.graphics.print(key..": "..value, 0, i)
        i = i + 15
    end
    i = i + 15
    love.graphics.print("Earth:", 0, i)
    i = i + 15
    for key, value in pairs(objects.venus) do
        love.graphics.print(key..": "..value, 0, i)
        i = i + 15
    end
    i = i + 15
    love.graphics.print("Mars:", 0, i)
    i = i + 15
    for key, value in pairs(objects.venus) do
        love.graphics.print(key..": "..value, 0, i)
        i = i + 15
    end--]]
end

function love.load()
    map = {
        x = 14959787070000,
        y = 14959787070000
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

    objects = {
        planet = {
            x = 0,
            y = 0,
            radius = 75,
            mass = 6 * 10 ^ 11,
            angle = 0,
            fgravity = 0,
            agravity = 0,
            vx = 0,
            vy = 0,
            acceleration = 0,
            xs = 0,
            ys = 0
        },    
        sat1 = {
            x = 0,
            y = -300,
            radius = 5,
            mass = 10,
            angle = 0,
            fgravity = 0,
            agravity = 0,
            vx = 200,
            vy = 0,
            acceleration = 2,
            xs = 0,
            ys = 0
        },
        sat2 = {
            x = 300,
            y = 0,
            radius = 5,
            mass = 10,
            angle = 0,
            fgravity = 0,
            agravity = 0,
            vx = 0,
            vy = 200,
            acceleration = 2,
            xs = 0,
            ys = 0
        },
        sat3 = {
            x = -300,
            y = 0,
            radius = 5,
            mass = 10,
            angle = 0,
            fgravity = 0,
            agravity = 0,
            vx = 0,
            vy = -200,
            acceleration = 2,
            xs = 0,
            ys = 0
        },
        sat4 = {
            x = 0,
            y = 300,
            radius = 5,
            mass = 10,
            angle = 0,
            fgravity = 0,
            agravity = 0,
            vx = -200,
            vy = 0,
            acceleration = 2,
            xs = 0,
            ys = 0
        }
    }

    G = 0.00006
end

function love.update(dt)
    mx, my = love.mouse.getPosition( )
    mxw, myw = editgrid.toWorld(camera, mx, my)
    for key1, value1 in pairs(objects) do
        for key2, value2 in pairs(objects) do
            if value1 ~= value2 then
                local distance = calcDistance(value1, value2)
                local angle1 = calcAngle(value2, value1)
                local angle2 = calcAngle(value1, value2)
                local f = calcGravityForce(value1, value2, distance)
                local acc1 = calcAcceleration(f, value1.mass)
                local acc2 = calcAcceleration(f, value2.mass)
                applyAcceleration(value1, angle1, acc1, dt)
                applyAcceleration(value2, angle2, acc2, dt)
                if checkCollision(value1, value2, distance) then
                    value1.vx = value1.vx / 10
                    value1.vy = value1.vy / 10
                    value2.vx = value2.vx / 10
                    value2.vy = value2.vy / 10
                end
                updatePosition(value1, dt)
                updatePosition(value2, dt)
                value2.xs, value2.ys = editgrid.toScreen(camera, value2.x, value2.y)
                value1.xs, value1.ys = editgrid.toScreen(camera, value1.x, value1.y)
            end
        end
    end
    control(objects.sat, angle)
end

function love.draw(dt)
    local grid = editgrid.grid(camera, visuals)
    grid:draw()
    drawUI()
    grid:push()
    for key, value in pairs(objects) do
        love.graphics.circle("fill", value.xs, value.ys, value.radius * camera.zoom)
    end
    love.graphics.pop()
end
