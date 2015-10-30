--[[
	Valikko
--]]


-- Luodaan valikkotila
valikko = {}


function valikko:init()
	
	paavalikko = Menu.new()

	paavalikko:addItem{
		nimi = "Aloita tarina",
		toiminto = function()
			--Gamestate.switch(alku)
			print("KESKEN")
		end
	}
	
	paavalikko:addItem{
		nimi = "Vapaa peli",
		toiminto = function()
			Gamestate.push( hahmovalikko )
			print("Tasovalikko")
		end
	}

	paavalikko:addItem{
		nimi = "Asetukset",
		toiminto = function()
			 Gamestate.push( asetukset )
			print("Asetukset")
		end
	}

	paavalikko:addItem{
		nimi = "Tekstit",
		toiminto = function()
			print("Lopputekstit")
			Gamestate.push( lopputekstit )
		end
	}
	
	paavalikko:addItem{
		nimi = "Lopeta",
		toiminto = function()
			print("Peli loppuu")
			love.event.quit()
		end
	}

end


function valikko:enter( mista )
	
	peliAlkanut=false
	
	TEsound.stop("musiikki")
	TEsound.playLooping("media/aanet/musiikki/paavalikko.ogg","musiikki")
	print("Soitetaan valikkomusiikki")

	self.mista = mista

end


function valikko:update( dt )

	paavalikko:update( dt )

end


function valikko:draw()

	love.graphics.draw( kuvat[ "testi_tausta.png" ], 0, 0 )

	paavalikko:draw( 100, 100 )

end


function valikko:keypressed( nappain )

	paavalikko:keypressed( nappain )

end
