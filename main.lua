wf = require 'windfield'

function love.load()
    love.window.setMode(640,360)
    love.window.setTitle('Siren')

    world = wf.newWorld(0,0,true)

    --player init
    player = world:newRectangleCollider(200,150, 32,44)
    player.speed = 100
    player:setFixedRotation(true)

    walls = {}
    walls[1] = world:newRectangleCollider(100+30,15,10,270)
    walls[2] = world:newRectangleCollider(530+30,15,10,270)
    walls[3] = world:newRectangleCollider(110+30,15,420,10)
    walls[4] = world:newRectangleCollider(110+30,275,420,10)
    --set types
    walls[1]:setType('static')
    walls[2]:setType('static')
    walls[3]:setType('static')
    walls[4]:setType('static')

    oven = {}
    oven.collider1 = world:newBSGRectangleCollider(180,20,134,37, 14)
    oven.collider2 = world:newRectangleCollider(226,20+37,43,20)
    oven.collider1:setType('static')
    oven.collider2:setType('static')
    oven.texture = love.graphics.newImage('Assets/Sprites/oven.png')
end

function love.update(dt)
    world:update(dt)

    vx = 0
    vy = 0

    if love.keyboard.isDown('right') then
        vx = player.speed
    end
    if love.keyboard.isDown('left') then
        vx = player.speed * -1
    end
    if love.keyboard.isDown('down') then
        vy = player.speed
    end
    if love.keyboard.isDown('up') then
        vy = player.speed * -1
    end

    player:setLinearVelocity(vx,vy)
end

function love.draw()
    world:draw()
    love.graphics.draw(oven.texture, 180,20)
end