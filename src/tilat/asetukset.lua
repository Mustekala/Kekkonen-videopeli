--[[
	Asetukset
--]]

asetukset = {}

function asetukset:init()
	onkoMusiikki=true
	debugMode=false 
	volyymi=1
	asetusvalikko= Menu.new()

	asetusvalikko:addItem{
		nimi = "Kokoruutu",
		toiminto = function()
			
			kokoruutu=not kokoruutu
			print("Kokoruutu:"..tostring(kokoruutu))
			love.window.setFullscreen(kokoruutu,"normal")

		end
	}

	asetusvalikko:addItem{
		nimi = "Volyymi",
		toiminto = function()
					
			 volyymi=volyymi+0.1
			 if volyymi > 1 then
			 volyymi=0
			 end
			 TEsound.volume("all",volyymi)
			 
			  print("Volyymi:"..volyymi)
			 TEsound.play("media/aanet/tehosteet/onkoaani.ogg")
			

		end
	}
	
	asetusvalikko:addItem{
		nimi = "Musiikki",
		toiminto = function()
			
			onkoMusiikki=not onkoMusiikki
			print("Musiikki:"..tostring(onkoMusiikki))
			if onkoMusiikki then
				TEsound.volume("musiikki",volyymi)
			else
				TEsound.volume("musiikki",0)
			end

		end
	}

	asetusvalikko:addItem{
		nimi = "Hud-tila",
		toiminto = function()
			
			if hudTila== "sydan" then
				hudTila = "numero"
			else
				hudTila = "sydan"
			end	
			print("hudTila:"..hudTila)
	
		end
	}
	
	asetusvalikko:addItem{
		nimi = "Debug",
		toiminto = function()
			
			debugMode=not debugMode
			print("Debug:"..tostring(debugMode))
	
		end
	}
end


function asetukset:enter( mista )

	self.mista = mista

end


function asetukset:update( dt )

	asetusvalikko:update( dt )

end


function asetukset:draw()

	love.graphics.draw( kuvat[ "testi_tausta.png" ], 0, 0 )

	asetusvalikko:draw( 100, 100 )

	if kokoruutu then
		love.graphics.print("Paalla", 550, 100)
	else
		love.graphics.print("Pois", 550, 100)
	end
	
	love.graphics.print((volyymi*100).."%", 550, 200)
	
	if onkoMusiikki then
		love.graphics.print("Paalla", 550, 300)
	else
		love.graphics.print("Pois", 550, 300)
	end
	
	love.graphics.print(hudTila, 550, 400)
	
	if debugMode then
		love.graphics.print("Paalla", 550, 500)
	else
		love.graphics.print("Pois", 550, 500)
	end
end


function asetukset:keypressed( nappain )

	if nappain=="escape" then
		Gamestate.pop()
	end
	
	asetusvalikko:keypressed( nappain )

end
