--[[
	Hahmovalikko
--]]

hahmovalikko = {}


function hahmovalikko:enter(taso)

--Molemmille pelaajille oma valikko
	
	elamaValikko = Menu.new()
	maxElamat=1

	--for _, hahmo in ipairs( hahmot ) do --Tämä on vähän turha, lisaa juttuja myohemmin

        elamaValikko:addItem{
			nimi = "Lisaa elama",
			toiminto = function()
				maxElamat=maxElamat+1
				print(maxElamat)			
			end
		}
		
		elamaValikko:addItem{	
			nimi="Aloita",		
			toiminto = function() 
				Gamestate.switch( tasovalikko, 2, maxElamat, {"kekkonen_blu", "kekkonen_red"})
				print( "Peli, hahmoina kekkonen_blu, kekkonen_red ")
			end
		}
		
	--end

end

function hahmovalikko:update( dt )

	elamaValikko:update( dt )

end

function hahmovalikko:draw()

	love.graphics.draw( kuvat[ "testi_tausta.png" ], 0, 0 )
	
	love.graphics.print( "Valitse hahmot ja elamat", 100, 10)
	
	love.graphics.draw( kuvat["Kekkonen_blu.png" ], 200, 100 ,0,3,3)
	love.graphics.draw( kuvat["Kekkonen_red.png" ], 200, 400 ,0,3,3)
	
	love.graphics.print( "Elamat", 550, 200)
	love.graphics.print(maxElamat, 575, 250)
	elamaValikko:draw( 550, 350, 60, 0.6 )
end

function hahmovalikko:keypressed( nappain )

	if nappain=="escape" then
		print( "Paavalikko" )
		Gamestate.pop()
	end
		
	elamaValikko:keypressed( nappain )
end
