
display.setStatusBar( display.HiddenStatusBar )

local composer = require( "composer" )

local scene = composer.newScene()  

local physics = require( "physics" )
physics.start()


-- tausta
local tausta = display.newImage( "skybg.png", display.actualContentWidth, display.actualContentHeight )

-- pilvet
local function clouds()
    local cloud = display.newImage( "cloud.png", -75, 260 )
	transition.to(cloud,{time=12500,x=465})
	cloud.alpha=0.9
	cloud:scale(4,4)

	local cloud2 = display.newImage( "cloud.png", 380, 160 )
	transition.to(cloud2,{time=8000,x=-70})
	cloud2.alpha=0.7
	cloud2:scale(2,2)

  	local cloud3 = display.newImage( "cloud.png", -50, 60 )
	cloud3.alpha=0.4
	transition.to(cloud3,{time=21000,x=405})
end
clouds()
timer.performWithDelay( 22000, clouds, 0 )

-- greendude
	local greenSheetData =  { width = 50, height= 50, numFrames = 10, sheetContentWidth=500, sheetContentHeight=50 }
	local greenSpriteSheet = graphics.newImageSheet("green.png" , greenSheetData)
	local greenSequenceData = { 
		{name = "idle", frames={1,2,3,4,5,6,7,8,9,10}, time=1000 },
	}		

-- veri
	local bloodSheetData =  { width = 320, height= 50, numFrames = 10, sheetContentWidth=3200, sheetContentHeight=50 }
	local bloodSpriteSheet = graphics.newImageSheet("blood.png" , bloodSheetData)
	local bloodSequenceData = { 
		{name = "dead", frames={1,2,3,4,5,6,7,8,9,10}, time=200, loopCount=1 },
	}		

-- piikit
local function SpawnSpikes()
	if(math.random(2)==1) then

halfWidth = display.contentWidth*0.5
local spikes = display.newImage( "spikes.png", halfWidth, 497 )
spikes:scale( 0.25 , 0.25 )
spikes.y = 475
else 
halfWidth = display.contentWidth*0.5
local spikes = display.newImage( "spikes2.png", halfWidth, 497 )
spikes:scale( 0.12 , 0.12 )
spikes.y = 475
end
end

SpawnSpikes()

-- pisteet
local score = 0
local scoreText = display.newText(score, 270 , 20, native.systemFont, 40)

-- äänet
local lol = audio.loadSound( "lol.wav" )
local pop = audio.loadSound( "pop.wav" )

-- painaminen
local function greenTouched(event)
	if ( event.phase == "began" ) then
        event.target:removeSelf()
        local pop = audio.play( pop )
		score = score + 1
		scoreText.text = score
    end
end


-- alas tippuneiden poisto
local function offscreen(self, event)
	if(self.y == nil) then
		return
	end
	if(self.y > display.contentHeight ) then 
		score = score - 1
		scoreText.text = score
		local blood = display.newSprite ( bloodSpriteSheet,bloodSequenceData)	
		blood:setSequence( "dead" )
		blood.x = halfWidth
		blood.y = 470
		blood:play()
        local lol = audio.play( lol )
		self:removeSelf()
	end
end

-- määritellään eri hahmojen spawni, nopeus ja koko.
local function SpawnGreen()
	if(math.random(3)==1) then
		local green = display.newSprite ( greenSpriteSheet,greenSequenceData)	
		green:setSequence( "idle" )
		green.x = math.random(display.contentWidth*0.1,display.contentWidth*0.9)
		green.y = -550
		green:play()
		green:scale(2.2,2.2)
		green.xScale = -2.2
		physics.addBody( green )
		green.enterFrame = offscreen
		Runtime:addEventListener( "enterFrame", green )
		green:addEventListener( "touch", greenTouched )

	elseif(math.random(1,3)==3) then
		local green = display.newSprite ( greenSpriteSheet,greenSequenceData)
		green:setSequence( "idle" )
		green:play()
		green:scale(1.9,1.9)
		green.x = math.random(display.contentWidth*0.1,display.contentWidth*0.9)
		green.y = -300
		physics.addBody( green )
		green.enterFrame = offscreen
		Runtime:addEventListener( "enterFrame", green )
		green:addEventListener( "touch", greenTouched )
	else 
		local green = display.newSprite ( greenSpriteSheet,greenSequenceData)
		green:setSequence( "idle" )
		green:play()
		green:scale(1.5,1.5)
		green.x = math.random(display.contentWidth*0.1,display.contentWidth*0.9)
		green.y = -100
		physics.addBody( green )
		green.enterFrame = offscreen
		Runtime:addEventListener( "enterFrame", green )
		green:addEventListener( "touch", greenTouched )
	end
end

-- vasen seinä  
local vSeina = display.newRect( -35, display.contentCenterY, 1200, 50 )
vSeina.strokeWidth = 10
vSeina.rotation=90
vSeina.isVisible = false 
physics.addBody(vSeina, "static", {density = 1.0, friction = 0.1, bounce = 0.5} )

-- oikea seinä
local oSeina = display.newRect( 350, display.contentCenterY, 1200, 50 )
oSeina.strokeWidth = 10
oSeina.rotation=90
oSeina.isVisible = false
physics.addBody(oSeina, "static", {density = 1.0, friction = 0.1, bounce = 0.5} )

-- seinä joka saa hahmon kimpoilemaan
local Seina = display.newRect( 15, -90, 70, 10 )
Seina.strokeWidth = 3
Seina.rotation=60
physics.addBody(Seina, "static", {density = 1.0, friction = 0.1, bounce = 2.0} )

-- Luo hahmon
SpawnGreen()

-- Kutsutaan funktiota jatkuvasti.
timer.performWithDelay( 450, SpawnGreen, 0 )

--vaikeusaste
local function vaikeus()
if score == 50 then
timer.performWithDelay( 850, SpawnGreen, 0 )
print("level 1")
elseif score == 150 then
timer.performWithDelay( 1400, SpawnGreen, 0 )
print("level 2")
elseif score == 200 then
timer.performWithDelay( 1000, SpawnGreen, 0 )
print("level 3")
end
end

-- tarkistetaan vaikeusaste jatkuvasti.
timer.performWithDelay( 800, vaikeus, 0 )


return scene