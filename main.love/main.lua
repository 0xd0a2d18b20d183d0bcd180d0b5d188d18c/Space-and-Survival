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
end

function love.wheelmoved(x, y)
    if y > 0 then
        scale = scale + 0.01
    elseif y < 0 then
        scale = scale - 0.01
    end
end

function drawUI()
    love.graphics.print('Sat.x: '..sat.x)
    love.graphics.print('Sat.y: '..sat.y, 0, 15)
    love.graphics.print('Sat.vy: '..sat.vy, 0, 30)
    love.graphics.print('Sat.vx: '..sat.vx, 0, 45)
    love.graphics.print('Scale: '..scale, 0, 60)
end

function love.load()
    love.window.setFullscreen(true)

    screen = {}
    screen.x = love.graphics.getWidth()
    screen.y = love.graphics.getHeight()

    planet = {}
    planet.x = 683
    planet.y = 384
    planet.radius = 75
    planet.mass = 6 * 10 ^ 11
    planet.v = 0
    planet.dv = 0

    sat = {}
    sat.x = 683
    sat.y = 200
    sat.radius = 5
    sat.mass = 100
    sat.angle = 0
    sat.vx = 400
    sat.vy = 0
    sat.acceleration = 2

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
end

function love.draw(dt)
    love.graphics.circle("fill", planet.x, planet.y, planet.radius)
    love.graphics.circle("fill", sat.x, sat.y, sat.radius)
    love.graphics.line(planet.x, planet.y, sat.x, sat.y)
    drawUI()
end
