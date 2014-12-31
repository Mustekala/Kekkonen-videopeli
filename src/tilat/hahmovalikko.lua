--[[
	Hahmovalikko
--]]

hahmovalikko = {}


function hahmovalikko:enter(taso)

--Molemmille pelaajille oma valikko
	
	hahmoValinta1 = Menu.new()
	hahmoValinta2 = Menu.new()
	valitutHahmot = {}
	
	muutValinnat = Menu.new()
	maxElamat = 0
	
	bottienMaara = 0
	
	local pelaajaMaara = 2 --TODO valinta talle
	
	valittuHahmo1 = hahmot[1]
	local hahmoLaskuri1 = 1
	valinta1Valmis = false
	hahmoValinta1:addItem{	

		nimi="Vaihda hahmo",		
		toiminto = function() 
			--Jos hahmot loppuvat, palaa alkuun
			if hahmot[hahmoLaskuri1+1] == nil then
				hahmoLaskuri1 = 1	
			else --Muuten seuraava hahmo
				hahmoLaskuri1 = hahmoLaskuri1 + 1
			end
			valittuHahmo1 = hahmot[hahmoLaskuri1]
			print(valittuHahmo1)
		end		
	}
	
	hahmoValinta1:addItem{	
		nimi="Valmis",		
		toiminto = function() 
			valinta1Valmis = true
			valitutHahmot[1] = valittuHahmo1
		end
	}
	
	
	valittuHahmo2 = hahmot[2]
	local hahmoLaskuri2 = 2
	valinta2Valmis = false
	hahmoValinta2:addItem{	

		nimi="Vaihda hahmo",		
		toiminto = function() 
			--Jos hahmot loppuvat, palaa alkuun
			if hahmot[hahmoLaskuri2+1] == nil then
				hahmoLaskuri2 = 1	
			else --Muuten seuraava hahmo
				hahmoLaskuri2 = hahmoLaskuri2 + 1
			end
			valittuHahmo2 = hahmot[hahmoLaskuri2]
			print(valittuHahmo2)
		end		
	}

	hahmoValinta2:addItem{	
		nimi="Valmis",		
		toiminto = function() 	
			valinta2Valmis = true
			valitutHahmot[2] = valittuHahmo2
		end
	}
	
	
    muutValinnat:addItem{
		nimi = "Lisaa elama",
		toiminto = function()
			maxElamat=maxElamat+1
			print(maxElamat)			
		end
	}
	
	muutValinnat:addItem{
		nimi = "Vahenna elama",
		toiminto = function()
			maxElamat=maxElamat-1
			print(maxElamat)			
		end
	}
	
	muutValinnat:addItem{
		nimi = "Onko botteja",
		toiminto = function()
			if bottienMaara <2 then
				bottienMaara = bottienMaara+1
			else
				bottienMaara = 0
			end
			print(bottienMaara)
		end
	}
	
	muutValinnat:addItem{
		
		nimi = "Aloita",
		toiminto = function()
			print("Peli, hahmoina:")
			for _, hahmo in ipairs(valitutHahmot) do
				print(hahmo)
			end
			
			Gamestate.switch(tasovalikko, 2, maxElamat, valitutHahmot, bottienMaara)
		 			
		end
	}
end

function hahmovalikko:update( dt )

	hahmoValinta1:update( dt )

	hahmoValinta2:update( dt )
	
	muutValinnat:update( dt )
	
end

function hahmovalikko:draw()

	love.graphics.draw( kuvat[ "testi_tausta.png" ], 0, 0 )
	
	love.graphics.print( "Valitse hahmot ja elamat", 0, 10)

	hahmoValinta1:draw( 50, 100, 60, 0.6 )
	love.graphics.draw( kuvat[valittuHahmo1..".png" ], 175, 130 ,0,3,3)
	
	if valittuHahmo1 == valittuHahmo2 then
		love.graphics.print("Samat hahmot lagaavat", 190, 130, 0, 0.5)
	end
	
	hahmoValinta2:draw( 500, 100, 60, 0.6 )
	love.graphics.draw( kuvat[valittuHahmo2..".png" ], 625, 130 ,0,3,3)
	
	if valinta1Valmis and valinta2Valmis then
		love.graphics.print( "Elamat: "..maxElamat, 460, 350, 0 , 0.7)
		love.graphics.print( "Botit: "..bottienMaara, 460, 470, 0 , 0.7)
		muutValinnat:draw( 200, 350, 60, 0.7 )
	end
end

function hahmovalikko:keypressed( nappain )
	if nappain=="escape" then
		print( "Paavalikko" )
		Gamestate.pop()
	end
	
	if not valinta2Valmis then	
		hahmoValinta2:keypressed( nappain )
	end	
	
	--Hahmovalinta1:lle omat kontollit
	if not valinta1Valmis then
		if nappain == "w" then
			hahmoValinta1:keypressed( "up" )
		elseif nappain == "s" then 
			hahmoValinta1:keypressed( "down" )
		elseif nappain == " " then 
			hahmoValinta1:keypressed( "return" )
		end
	end	
	
	if valinta1Valmis and valinta2Valmis then
		muutValinnat:keypressed( nappain )
	end	
	
end
