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
    love.window.setIcon(love.image.newImageData("Assets/Sprites/icon.png"))
    love.graphics.setDefaultFilter("nearest","nearest")

    canvas = love.graphics.newCanvas(virtualWidth,virtualHeight)

    world = wf.newWorld(0,0,true)

    world:addCollisionClass('CoalTrigger')
    world:addCollisionClass('OvenTrigger')
    world:addCollisionClass('player', {ignores = {'CoalTrigger',"OvenTrigger"}})

    Background = love.graphics.newImage("Assets/Sprites/Background.png")
    MapBack = love.graphics.newImage("Assets/Sprites/map.png")

    ----------------
    walls = {}
    walls[1] = world:newRectangleCollider(130+15,15,10,270)
    walls[2] = world:newRectangleCollider(560+15,15,10,270)
    walls[3] = world:newRectangleCollider(140+15,15,420,10)
    walls[4] = world:newRectangleCollider(140+15,275,420,10)
    walls[1]:setType('static')
    walls[2]:setType('static')
    walls[3]:setType('static')
    walls[4]:setType('static')
    
    Walls = love.graphics.newImage('Assets/Sprites/walls.png')
    ----------------

    --player init
    player = world:newBSGRectangleCollider(210,215, 32,44,8)
    player:setFixedRotation(true)
    player:setCollisionClass('player')
    player.SpriteSheet = love.graphics.newImage("Assets/Sprites/ZamiSpSh.png")
    player.speed = 80
    player.isLeft = false
    player.hasCoal = false
    player.GrabbedCoal = 15

    --player animations set up
    --set grid
    player.AnimGrid = anim8.newGrid(34,44, 272,92)

    --animations
    player.Animations = {}
    player.Animations.IdleClothed = anim8.newAnimation(player.AnimGrid('1-2', 1),0.5)
    player.Animations.WalkClothed = anim8.newAnimation(player.AnimGrid('3-4', 1),0.3)
    player.Animations.IdleClothedCoal = anim8.newAnimation(player.AnimGrid('5-6', 1),0.5)
    player.Animations.WalkClothedCoal = anim8.newAnimation(player.AnimGrid('7-8', 1),0.3)
    player.Animations.IdleNude = anim8.newAnimation(player.AnimGrid('1-2', 2),0.5)
    player.Animations.WalkNude = anim8.newAnimation(player.AnimGrid('3-4', 2),0.3)
    player.Animations.IdleNudeCoal = anim8.newAnimation(player.AnimGrid('5-6', 2),0.5)
    player.Animations.WalkNudeCoal = anim8.newAnimation(player.AnimGrid('7-8', 2),0.3)

    player.AnimSet = player.Animations.IdleClothed
    --------------------------

    oven = {}
    oven.collider1 = world:newBSGRectangleCollider(200,20,134,37, 16)
    oven.collider2 = world:newRectangleCollider(245,57,45,20)
    oven.collider1:setType('static')
    oven.collider2:setType('static')
    oven.triggerCollider = world:newRectangleCollider(235,57,65,30)
    oven.triggerCollider:setType('static')
    oven.triggerCollider:setCollisionClass('OvenTrigger')
    oven.fullTexture = love.graphics.newImage('Assets/Sprites/ovenFull.png')
    oven.halfTexture = love.graphics.newImage('Assets/Sprites/ovenHalf.png')
    oven.emptyTexture = love.graphics.newImage('Assets/Sprites/ovenEmpty.png')
    oven.CoalLvl = 100

    coal = {}
    coal.texture = love.graphics.newImage("Assets/Sprites/coal.png")
    coal.collider = world:newRectangleCollider(430,250, 64,24)
    coal.collider:setType("static")
    coal.triggerCollider = world:newRectangleCollider(420,240,85,35)
    coal.triggerCollider:setType("static")
    coal.triggerCollider:setCollisionClass('CoalTrigger')
end

function love.update(dt)
    updateScale()

    world:update(dt)

    oven.CoalLvl = oven.CoalLvl - 3 * dt

    if player.isMove == false then
        if player.hasCoal == false then
            player.AnimSet = player.Animations.IdleClothed
        elseif player.hasCoal == true then
            player.AnimSet = player.Animations.IdleClothedCoal
        end
    elseif player.isMove == true then
        if player.hasCoal == false then
            player.AnimSet = player.Animations.WalkClothed
        elseif player.hasCoal == true then
            player.AnimSet = player.Animations.WalkClothedCoal
        end
    end
    playerMovement()

    if player:enter('CoalTrigger') and player.hasCoal == false then
        player.hasCoal = true
    end
    if player:enter('OvenTrigger') and player.hasCoal == true then
        player.hasCoal = false
        oven.CoalLvl = oven.CoalLvl + player.GrabbedCoal
    end

    player.AnimSet:update(dt)
end

function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    love.graphics.draw(Background,0,0)
    love.graphics.draw(MapBack,110+15,0)

    if oven.CoalLvl >= 50 then
        love.graphics.draw(oven.fullTexture,180+20,20)
    elseif oven.CoalLvl <= 50 and oven.CoalLvl >= 15 then
        love.graphics.draw(oven.halfTexture,180+20,20)
    elseif oven.CoalLvl <= 15 then
        love.graphics.draw(oven.emptyTexture,180+20,20)
    end

    if player.isLeft == false then
        player.AnimSet:draw(player.SpriteSheet, player:getX()-16, player:getY()-22)
    elseif player.isLeft == true then
        player.AnimSet:draw(player.SpriteSheet, player:getX()+16, player:getY()-22, nil, -1,1)
    end

    love.graphics.draw(Walls, 130+15,15)
    love.graphics.draw(coal.texture, 430,224)

    love.graphics.print(oven.CoalLvl)

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

    player.isMove = false

    if love.keyboard.isDown('right') then
        vx = player.speed
        player.isLeft = false
        player.isMove = true
    end
    if love.keyboard.isDown('left') then
        vx = player.speed * -1
        player.isLeft = true
        player.isMove = true
    end
    if love.keyboard.isDown('down') then
        vy = player.speed
        player.isMove = true
    end
    if love.keyboard.isDown('up') then
        vy = player.speed * -1
        player.isMove = true
    end

    player:setLinearVelocity(vx,vy)

end

function updateScale()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    scaleX = windowWidth / virtualWidth
    scaleY = windowHeight / virtualHeight
    scale = math.min(scaleX, scaleY)
end

--[[function love.resize(w, h)
    updateScale()
end]]--