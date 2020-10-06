display.setStatusBar( display.HiddenStatusBar )

local composer = require("composer")

local scene = composer.newScene()

local function gotoGame()
		composer.gotoScene("game")
end

function scene:create( event )
		local sceneGroup = self.view
		local bg = display.newImageRect( sceneGroup, "fall.png", display.actualContentWidth, display.actualContentHeight)
		bg.x = display.contentCenterX
		bg.y = display.contentCenterY
		
		local playbutton = display.newImage( sceneGroup, "play.png",630,298)
		playbutton.x = display.contentCenterX
		playbutton.y = display.contentCenterY -550
        playbutton:scale(2.8,1.8)
        transition.to(playbutton,{time=2000,y=260,rotation=360})
		playbutton:addEventListener("touch", gotoGame)	
end		

local bgmusic = audio.loadSound ( "bgmusic.mp3" )
local bgmusic = audio.play( bgmusic, { loops=-1} )

scene:addEventListener( "create", scene )

local credits = "made by Janne Kytölä"
local creditsText = display.newText(credits, -100 , 518, native.systemFont, 16)
creditsText:setFillColor(black)
transition.to(creditsText,{time=9000,x=240, transition=easing.inOutCubic})

return scene