local physics = {}

function calcGravityForce(object1, object2, distance)
    local G = 0.00006
    return G * ((object2.mass * object1.mass) / (math.abs(object1.x - object2.x) ^ 2 + math.abs(object1.y - object2.y) ^ 2))
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

function applyAcceleration(object, angle, a, dt)
    object.vx = object.vx + math.cos(angle) * a * dt
    object.vy = object.vy + math.sin(angle) * a * dt
end

function applyAngularVelocity(object, dt)
    object.angle = object.angle + object.va * dt
end

return physics
