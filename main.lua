wf = require 'Assets/Modules/windfield'
anim8 = require 'Assets/Modules/anim8'

local virtualWidth = 640
local virtualHeight = 360
local scale = 1
local scaleX, scaleY = 1, 1
local canvas

function love.load()
    local winWidth, winHeight = 1280,720
    love.window.setMode(winWidth,winHeight, {resizable=true})
    love.window.setTitle('Siren')
    love.graphics.setDefaultFilter("nearest","nearest")

    canvas = love.graphics.newCanvas(virtualWidth,virtualHeight)

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
    
    Walls = love.graphics.newImage('Assets/Sprites/walls.png')
    ----------------

    --player init
    player = world:newBSGRectangleCollider(200,150, 32,44,8)
    player.speed = 80
    player.isLeft = false
    player:setFixedRotation(true)
    player.SpriteSheet = love.graphics.newImage("Assets/Sprites/ZamiSpSh.png")

    --player animations set up
    --set grid
    player.AnimGrid = anim8.newGrid(34,44, 272,92)

    --animations
    player.Animations = {}
    player.Animations.IdleClothes = anim8.newAnimation(player.AnimGrid('1-2', 1),0.5)
    player.Animations.WalkClothes = anim8.newAnimation(player.AnimGrid('3-4', 1),0.3)

    player.AnimSet = player.Animations.IdleClothes
    --------------------------

    oven = {}
    oven.collider1 = world:newBSGRectangleCollider(180+20,20,134,37, 16)
    oven.collider2 = world:newRectangleCollider(225+20,20+37,45,20)
    oven.collider1:setType('static')
    oven.collider2:setType('static')
    oven.texture = love.graphics.newImage('Assets/Sprites/oven.png')

    coal = {}
    coal.texture = love.graphics.newImage("Assets/Sprites/coal.png")
    coal.collider = world:newRectangleCollider(430,250, 64,24)
    coal.collider:setType("static")
end

function love.update(dt)
    updateScale()

    world:update(dt)

    player.AnimSet = player.Animations.IdleClothes

    playerMovement()

    player.AnimSet:update(dt)
end

function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    love.graphics.draw(oven.texture, 180+20,20)

    if player.isLeft == false then
        player.AnimSet:draw(player.SpriteSheet, player:getX()-16, player:getY()-22)
    elseif player.isLeft == true then
        player.AnimSet:draw(player.SpriteSheet, player:getX()+16, player:getY()-22, nil, -1,1)
    end

    love.graphics.draw(Walls, 130,15)
    love.graphics.draw(coal.texture, 430,224)

    --world:draw()

    love.graphics.setCanvas()

    love.graphics.draw(canvas,
    (love.graphics.getWidth() - virtualWidth * scale) * 0.5,
    (love.graphics.getHeight() - virtualHeight * scale) * 0.5,
    0, scale, scale)
end

function playerMovement()

    vx = 0
    vy = 0

    if love.keyboard.isDown('right') then
        vx = player.speed
        player.isLeft = false
        player.AnimSet = player.Animations.WalkClothes
    end
    if love.keyboard.isDown('left') then
        vx = player.speed * -1
        player.isLeft = true
        player.AnimSet = player.Animations.WalkClothes
    end
    if love.keyboard.isDown('down') then
        vy = player.speed
        player.AnimSet = player.Animations.WalkClothes
    end
    if love.keyboard.isDown('up') then
        vy = player.speed * -1
        player.AnimSet = player.Animations.WalkClothes
    end

    player:setLinearVelocity(vx,vy)

end

function updateScale()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    scaleX = windowWidth / virtualWidth
    scaleY = windowHeight / virtualHeight
    scale = math.min(scaleX, scaleY)
end

function love.resize(w, h)
    updateScale()
end