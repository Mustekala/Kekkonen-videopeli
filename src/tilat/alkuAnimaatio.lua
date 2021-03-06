alkuAnimaatio = {nimi = "intro", nopeus = 1, tila = "teksti1", kulunutAika = 0, teksti="Kiuruveden kirvesmies \n sen tiesi"}

--Alkuanimaatio pelille. Kertoo nerokkaan taustatarinan 
function alkuAnimaatio:init()
	TEsound.play(MUSIIKKI_POLKU.."Intro.ogg", "musiikki", 1, 1, vaihdaState)
end

function alkuAnimaatio:update(dt)

	self.kulunutAika = self.kulunutAika + dt
	if self.tila == "teksti1"  then
		if self.kulunutAika > 2.5 then --2.5
			self.tila = "teksti2" 
		end	
	elseif self.tila == "teksti2"  then
		self.teksti="Kekkosella oli\nkaksoisolento"
		if self.kulunutAika > 7.8 then --7.8
			self.tila = "teksti3" 
		end
	elseif self.tila == "teksti3"  then
		self.teksti="Mutta harva tietaa"
		if self.kulunutAika > 12.8 then --12.8
			self.tila = "teksti4" 
		end
	elseif self.tila == "teksti4"  then
		self.teksti="Heidan taistelustaan"
		if self.kulunutAika > 18 then --18
			self.tila = "pelaaja1" 
		end		
	elseif self.tila == "pelaaja1"  then
		camera._x = camera._x + 0.43 * self.nopeus 
		camera._y = camera._y + 0.5 * self.nopeus 
		camera.scaleY = camera.scaleY - 0.002 * self.nopeus
		camera.scaleX = camera.scaleX - 0.002 * self.nopeus
		if camera.scaleY < 0.05 then
			self.tila = "zoomOut" 
		end	
	elseif self.tila == "zoomOut" then
		camera._x = camera._x + 1 * self.nopeus
		camera._y = camera._y - 0.2 * self.nopeus
		camera.scaleY = camera.scaleY + 0.001 * self.nopeus
		camera.scaleX = camera.scaleX + 0.001 * self.nopeus
		if camera.scaleY > 0.38 then
			self.tila = "pelaaja2" 
		end		
	elseif self.tila == "pelaaja2"  then
		camera._x = camera._x + 0.2 * self.nopeus
		camera._y = camera._y + 0.45 * self.nopeus
		camera.scaleY = camera.scaleY - 0.002 * self.nopeus
		camera.scaleX = camera.scaleX - 0.002 * self.nopeus
		if camera.scaleY < 0.05 then
			self.tila = "teksti" 
		end	
	elseif self.tila == "teksti" then
		camera._x = camera._x + 1 * self.nopeus
		camera._y = camera._y - 0.15 * self.nopeus
		camera.scaleY = camera.scaleY + 0.001 * self.nopeus
		camera.scaleX = camera.scaleX + 0.001 * self.nopeus
		if camera.scaleY > 0.4 then
			self.tila = "pysahdy" 
		end
	end	
end

function alkuAnimaatio:draw()
	
	local taustaX = camera._x *-1 /5  -100 --Taustat liikkuvat kameran mukana, mutta maltillisemmin
	local taustaY = camera._y *-1 /10 -100
	local taustaZoom = camera.scaleX/10 --Ei jarkeva kayttaa
	love.graphics.draw(kuvat["Eduskunta_tausta.png"], taustaX, taustaY, 0, 2, 2) --Tason tausta piirtyy erikseen
	
	if self.tila == "teksti1" or self.tila == "teksti2" or self.tila == "teksti3" or self.tila == "teksti4" then
		love.graphics.print(self.teksti, 100, 200)
	else
		camera:set()
		love.graphics.draw(kuvat["eduskunta_alkuAnimaatio.png"], 0, 300, 0, 0.835,0.8)
		love.graphics.draw(kuvat["Kekkonen_alkuAnimaatio.png"], 200, 245, 0, 1, 1)
		love.graphics.draw(kuvat["Kekkonen_alkuAnimaatio.png"], 600, 245, 0, -1, 1)
		love.graphics.print("KEKKONEN\n VIDEOPELI", 950, 240, 0 ,0.5, 0.5)
		camera:unset()
	end
	love.graphics.draw(kuvat["sepia_alkuAnimaatio.png"], math.random(-4,0), math.random(-4,0), 0, 1.01, 1.01)
end

function vaihdaState()
	TEsound.stop("musiikki")
	Gamestate.switch( avausRuutu )	
end

function alkuAnimaatio:keypressed( nappain )

	if nappain == "return" then
		vaihdaState()
	end

end