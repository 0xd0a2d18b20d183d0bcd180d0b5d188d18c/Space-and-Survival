local physics = {}

function calcGravityForce(object1, object2)
    local G = 0.00006
    return G * ((object2.mass * object1.mass) / (math.abs(object1.x - object2.x) ^ 2 + math.abs(object1.y - object2.y) ^ 2))
end

function calcAcceleration(f, m)
    return f / m
end

function checkCollision(object1, object2, distance)
    return distance < (object1.radius + object2.radius)
end

function applyAcceleration(object, angle, a, dt)
    object.vx = object.vx + math.cos(angle) * a * dt
    object.vy = object.vy + math.sin(angle) * a * dt
end

function applyAngularVelocity(object, dt)
    object.angle = object.angle + object.va * dt
end

function destroyObjects(object1, key1, object2, key2)
    if object1.type == "sat" and object2.type == "sat" then
        objects[key1] = nil
        objects[key2] = nil
    end
    if object1.type == "sat" and object2.type == "moon" then
        objects[key1] = nil
    end
    if object1.type == "moon" and object2.type == "moon" then
        objects[key1] = nil
        objects[key2] = nil
    end
end

return physics
