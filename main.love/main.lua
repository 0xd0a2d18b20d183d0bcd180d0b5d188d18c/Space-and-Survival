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
    sat.y = 100
    sat.radius = 5
    sat.mass = 100
    sat.angle = 0
    sat.vx = 400
    sat.vy = 0
    sat.acceleration = 200
    sat.v = 0
    sat.dv = 0
    k = 0
    G = 0.00006
    f = 0
end

function love.update(dt)
    radius = math.sqrt((math.abs(planet.x - sat.x) ^ 2) + (math.abs(planet.y - sat.y) ^ 2))

    k = (planet.y - sat.y) / (planet.x - sat.x)
    
    sat.angle = math.atan2(planet.y - sat.y, planet.x - sat.x)

    if radius > planet.radius then
        f = (G * ((sat.mass * planet.mass) / radius ^ 2))
    end

    a = f / sat.mass

    sat.vx = sat.vx + math.cos(sat.angle) * a * dt
    sat.vy = sat.vy + math.sin(sat.angle) * a * dt
    sat.x = sat.x + sat.vx * dt
    sat.y = sat.y + sat.vy * dt

    --[[
    if sat.x < 0 then
		sat.x = sat.x + screen.x
	end
	if sat.y < 0 then
		sat.y = sat.y + screen.y
	end
	if sat.x > screen.x then
		sat.x = sat.x - screen.x  
	end
	if sat.y > screen.y then
		sat.y = sat.y - screen.y
    end
    --]]
end

function love.draw(dt)
    love.graphics.print(sat.x, 5, 25)
    love.graphics.print(sat.y, 5, 50)
    love.graphics.print(sat.vy, 5, 75)
    love.graphics.print(sat.vx, 5, 100)
    love.graphics.print(f, 5, 150)
    love.graphics.print(radius, 5, 175)
    love.graphics.print(sat.angle, 5, 125)
    love.graphics.circle("fill", planet.x, planet.y, planet.radius)
    love.graphics.circle("fill", sat.x, sat.y, sat.radius)
    love.graphics.line(planet.x, planet.y, sat.x, sat.y);
end