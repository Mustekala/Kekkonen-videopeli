

kontrollit = {}


function kontrollit:enter(  )
	kontrollivalikko=Menu.new()
	
	for i = 1, 2 do
	
		kontrollivalikko:addItem{
			nimi = "Pelaaja"..i.." ylos:",
			toiminto = function()
				Gamestate.push(kontrolliValinta, pelaajienKontrollit[i].YLOS, "Pelaaja"..i.." ylos:")			
			end
		}
	
	end
end


function kontrollit:update( dt )
	
	kontrollivalikko:update(dt)

end


function kontrollit:draw()

	kontrollivalikko:draw(100,200)
	
end


function kontrollit:keypressed( nappain )
	
	if nappain == "escape" then
		Gamestate.pop()
		print("Asetukset")
	end

	kontrollivalikko:keypressed(nappain)
end

function kontrollit:leave()

end