

kontrolliValinta = {}


function kontrolliValinta:enter( aiempi, kontrolli, nimi )
	
	self.nimi = nimi
	self.kontrolli = kontrolli
	
end


function kontrolliValinta:update( dt )

end


function kontrolliValinta:draw()
	
	love.graphics.print("Minka nappaimen haluat laittaa \nkontrolliin "..self.nimi, 10, 20, 0 , 0.8, 0.8)
	
end


function kontrolliValinta:keypressed( nappain )
	
	if nappain == "escape" then
		Gamestate.pop()
		print("Asetukset")
	end

	--Asetetaan nappain kontrolliin ja palataan aiempaan stateen	
	print(self.kontrolli)
	self.kontrolli = nappain
	print(self.kontrolli)
	Gamestate.pop()
	
end
