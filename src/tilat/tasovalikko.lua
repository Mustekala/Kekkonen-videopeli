--[[
	Tasovalikko
--]]


tasovalikko = {}


function tasovalikko:enter(aiempi , pelaajaMaara, elamienMaara, hahmot, bottiValinta1, bottiValinta2)
	self.nimi = "tasovalikko"
	
	tasojenValikko = Menu.new()
		
	for _, tasonNimi in pairs( tasoVarasto ) do

		tasojenValikko:addItem{
			nimi = tasonNimi,
			toiminto = function()

				print( "Tasona " .. tasonNimi )
				Gamestate.switch( peli, tasonNimi, pelaajaMaara, elamienMaara, hahmot, bottienMaara)
			end
		}

	end

end

function tasovalikko:update( dt )

	tasojenValikko:update( dt )

	--print( tasojenValikko.items[tasojenValikko.selected].nimi )

end

function tasovalikko:draw()
	
	love.graphics.draw( kuvat[ "testi_tausta.png" ], 0, 0 )
	
	love.graphics.print( "Valitse taso", 100, 10)
	
	love.graphics.draw( kuvat[ tasojenValikko.items[tasojenValikko.selected].nimi .. ".png" ], 40, 200 ,0,0.8,0.8)
	love.graphics.draw( kuvat[ "kekkonen_kehys.png" ], 0, 50 ,0,0.9)--Kekkonen-kehys
	
	tasojenValikko:draw( 550, 200, 60, 0.6 )

end

function tasovalikko:keypressed( nappain )

	if nappain=="escape" then
		print( "Paavalikko" )
		Gamestate.switch(valikko)
	
	elseif nappain == "f1" then
		Gamestate.push(apuva, "tasovalikko")
	end

	tasojenValikko:keypressed( nappain )

end
