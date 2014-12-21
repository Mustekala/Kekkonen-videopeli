--[[
	Valikko
--]]


-- Luodaan valikkotila
paussivalikko = {}


function paussivalikko:init()

	pValikko = Menu.new()

	pValikko:addItem{
		nimi = "Jatka pelia",
		toiminto = function()
			Gamestate.pop()
			print("Takaisin peliin")
		end
	}

	pValikko:addItem{
		nimi = "Asetukset",
		toiminto = function()
			Gamestate.push( asetukset)
			print("Asetukset")
		end
	}
	
	pValikko:addItem{
		nimi = "Paavalikko",
		toiminto = function()
			Gamestate.push( valikko , "paussivalikko")
			print("Valikko")
		end
	}
	
	pValikko:addItem{
		nimi = "Lopeta",
		toiminto = function()
			print("Peli loppuu")
			love.event.quit()
		end
	}

end


function paussivalikko:enter( mista )

	self.mista = mista

end


function paussivalikko:update( dt )

	pValikko:update( dt )

end


function paussivalikko:draw()
	peli:draw()
	love.graphics.draw( kuvat[ "paussi_tausta.png" ], 0, 0 ) --Paussitausta on 25% läpinäkyvä

	pValikko:draw( 100, 200 )

end


function paussivalikko:keypressed( nappain )
	if nappain == "escape" then
		
		Gamestate.push(peli)
		print("Takaisin peliin")
	end
	pValikko:keypressed( nappain )

end