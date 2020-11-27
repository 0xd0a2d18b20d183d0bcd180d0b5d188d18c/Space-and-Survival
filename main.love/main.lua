local gamera = require 'gamera'

cam = gamera.new(0,0,2000,2000)
cam:setWindow(0,0,1366,768)

function love.wheelmoved(x, y)
    if y > 0 then
        i = i + 0.01
    elseif y < 0 then
        i = i - 0.01
    end
    cam:setScale(i)
end

function drawUI()
    love.graphics.print('Sat.x: '..sat.x)
    love.graphics.print('Sat.y: '..sat.y, 0, 15)
    love.graphics.print('Sat.vy: '..sat.vy, 0, 30)
    love.graphics.print('Sat.vx: '..sat.vx, 0, 45)
    love.graphics.print('Sat.f: '..f, 0, 60)
    love.graphics.print('Radius: '..radius, 0, 75)
    love.graphics.print('Sat.angle: '..sat.angle, 0, 90)
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
    sat.v = 0
    sat.dv = 0
    k = 0
    G = 0.00006
    f = 0
    i = 1
end

function love.update(dt)
    radius = math.abs(planet.x - sat.x) ^ 2 + math.abs(planet.y - sat.y) ^ 2
    
    sat.angle = math.atan2(planet.y - sat.y, planet.x - sat.x)

    if radius > planet.radius then
        f = (G * ((sat.mass * planet.mass) / radius))
    end

    a = f / sat.mass

    sat.vx = sat.vx + math.cos(sat.angle) * a * dt
    sat.vy = sat.vy + math.sin(sat.angle) * a * dt

    if love.keyboard.isDown('up') then
        sat.vx = sat.vx + math.cos(sat.angle - 1.5708) * sat.acceleration
        sat.vy = sat.vy + math.sin(sat.angle - 1.5708) * sat.acceleration
    end

    if love.keyboard.isDown('down') then
        sat.vx = sat.vx + math.cos(sat.angle + 1.5708) * sat.acceleration
        sat.vy = sat.vy + math.sin(sat.angle + 1.5708) * sat.acceleration
    end

    sat.x = sat.x + sat.vx * dt
    sat.y = sat.y + sat.vy * dt

    if love.mouse.isDown( 1 ) then
        x, y = love.mouse.getPosition()
        cam:setPosition(x, y)
    end
end

function love.draw(dt)
    cam:draw(function(l,t,w,h)
        love.graphics.circle("fill", planet.x, planet.y, planet.radius)
        love.graphics.circle("fill", sat.x, sat.y, sat.radius)
        love.graphics.line(planet.x, planet.y, sat.x, sat.y)
      end)
    drawUI()
end
