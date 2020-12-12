local camera = require "camera"
local physics = require "physics"
local geometry = require "geometry"
local controls = require "controls"
local debug = require "debug"
local world = require "world"
local json = require "json"

function love.load()
    map, settings, objects, cursor = initWorld()
    stop = 0
    tempx = 0
    tempy = 0
end

function love.update(dt)
    if stop == 0 then
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
                end
            end
            applyAngularVelocity(value1, dt)
            updatePosition(value1, dt)
            value1.xs, value1.ys = camera.toScreen(settings, value1.x, value1.y)
        end
        for key, value in pairs(objects) do
            if value.controlled == 1 then
                controls(value, dt)
            end
        end
    end
    cursor.sx, cursor.sy = love.mouse.getPosition( )
    cursor.x, cursor.y = camera.toWorld(settings, cursor.sx / settings.zoom, cursor.sy / settings.zoom)
    cameraControls()
end

function love.mousepressed(x, y, button, istouch)
    tempx, tempy = camera.toWorld(settings, x, y)
    if button == 1 then
        table.insert(objects, {
            x = tempx,
            y = tempy,
            radius = 5,
            mass = 10,
            angle = 0,
            controlled = 1,
            vx = math.random(-400, 400),
            vy = math.random(-400, 400),
            va = 0,
            acceleration = 100,
            rotation = math.pi,
            image = love.graphics.newImage("assets/sat.png"),
            xs = 0,
            ys = 0
        })
    end
end

local charset = {}  do -- [0-9a-zA-Z]
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 65, 90  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

function randomString(length)
    if not length or length <= 0 then return '' end
    math.randomseed(os.clock()^5)
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end

function love.draw(dt)
    local camera = camera.init(settings)
    local i = 0
    local dist = 15
    love.graphics.print("Cursor.sx:"..cursor.sx, 0, i)
    i = i + dist
    love.graphics.print("Cursor.sy:"..cursor.sy, 0, i)
    i = i + dist
    love.graphics.print("Cursor.wx:"..cursor.x, 0, i)
    i = i + dist
    love.graphics.print("Cursor.wy:"..cursor.y, 0, i)
    i = i + dist
    love.graphics.print("Temp.x:"..tempx, 0, i)
    i = i + dist
    love.graphics.print("Temp.y:"..tempy, 0, i)
    i = i + dist
    for key, value in pairs(objects) do
        love.graphics.print(key, 0, i)
        i = i + dist
            for key, value2 in pairs(value) do
            if key ~= "image" then
                love.graphics.print(key..": "..value2, 0, i)
                i = i + dist
            end
        end
    end
        camera:push()
    for key, value in pairs(objects) do
        love.graphics.draw(value.image, value.xs, value.ys, value.angle, settings.zoom, settings.zoom, value.image:getWidth() / 2, value.image:getHeight() / 2)
        love.graphics.line(value.xs, value.ys, (value.xs + value.vx) * settings.zoom, (value.ys + value.vy) * settings.zoom)
    end
    love.graphics.pop()
end
