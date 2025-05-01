wf = require 'Assets/Modules/windfield'
anim8 = require 'Assets/Modules/anim8'

function love.load()
    love.window.setMode(640,360)
    love.window.setTitle('Siren')

    world = wf.newWorld(0,0,true)

    ----------------
    walls = {}
    walls[1] = world:newRectangleCollider(130,15,10,270)
    walls[2] = world:newRectangleCollider(560,15,10,270)
    walls[3] = world:newRectangleCollider(140,15,420,10)
    walls[4] = world:newRectangleCollider(140,275,420,10)
    walls[1]:setType('static')
    walls[2]:setType('static')
    walls[3]:setType('static')
    walls[4]:setType('static')
    ----------------

    --player init
    player = world:newRectangleCollider(200,150, 32,44)
    player.speed = 80
    player:setFixedRotation(true)
    player.SpriteSheet = love.graphics.newImage("Assets/Sprites/ZamiSpSh.png")

    --player animations set up
    --set grid
    player.AnimGrid = anim8.newGrid(34,44, 272,92)

    player.Animations = {}
    player.Animations.IdleClothes = anim8.newAnimation(player.AnimGrid('1-2', 1),0.5)
    --------------------------

    oven = {}
    oven.collider1 = world:newBSGRectangleCollider(180+20,20,134,37, 16)
    oven.collider2 = world:newRectangleCollider(226+20,20+37,43,20)
    oven.collider1:setType('static')
    oven.collider2:setType('static')
    oven.texture = love.graphics.newImage('Assets/Sprites/oven.png')

    
    Walls = love.graphics.newImage('Assets/Sprites/walls.png')
end

function love.update(dt)
    world:update(dt)

    playerMovement()

    player.Animations.IdleClothes:update(dt)
end

function love.draw()
    love.graphics.draw(oven.texture, 180+20,20) --draw oven lol
    player.Animations.IdleClothes:draw(player.SpriteSheet, player:getX()-16, player:getY()-22)
    love.graphics.draw(Walls, 130,15) --draw walls, lol
    world:draw()
end

function playerMovement()

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