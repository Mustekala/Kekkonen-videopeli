--[[
	Tunarit-ruutu, joka tulee, jos molemmat pelaajat kuolivat lahes samaan aikaan
--]]


-- Luodaan itse tunarit-tila pelille
tunarit = {

}

function tunarit:init()
	
	--TEsound.playLooping("media/aanet/musiikki/voittoRuutu.ogg", "musiikki") TODO etsi joku kiva musiikki
	print("Loopataan haviomusiikki")
	self.nimi = "tunarit"
	lumisade_anim = newAnimation(kuvat["tv_noise.png"], 512, 512, 0.1, 8)
end

function tunarit:enter(wanhaState, wanhaTaso, wanhatElamat, wanhatHahmot)
	
	ajastin = 0 --Asetetaan ajastin
	lumisade = false
	
	peliAlkanut = false
	--Pysaytetaan kaikki aanet 
	TEsound.stop("musiikki")
	TEsound.stop("tausta")
	
	print("WanhatElamat:"..wanhatElamat)
	tunarit.taso = wanhaTaso
	tunarit.elamat = wanhatElamat
	tunarit.hahmot = wanhatHahmot
	print("Kumpikaan pelaajista ei voittanut\nKekkonen on vihainen, nyt alkaa sataa")
end

function tunarit:update( dt )

	if lumisade then
		ajastin = ajastin + dt
		lumisade_anim:update(dt)
	end	
	if ajastin > 1.5 then
		print( "Uusi peli,"..self.taso)
		Gamestate.switch( peli, self.taso, 2, self.elamat, self.hahmot, 0)
	end	
end


function tunarit:draw()
	
	-- Piiretaan tausta
	love.graphics.draw( kuvat[ "Ukk_tausta_pikseloity.png" ], 0, 0, 0, 1.5, 1.6)

	-- Piirretaan suuri nimi/title
	love.graphics.print("Saatanan tunarit\nHavisitte molemmat!", 10, 50, 0, 1.5, 1.5 )

	love.graphics.print( "Kokeillaanpas uudestaan (enter)", 60, 400, 0, 0.6, 0.6 )
	
	if lumisade then
		lumisade_anim:draw(0, 0, 0, 2, 2)
	end

end


function tunarit:keypressed( nappain )

	-- Tarkistetaan mita nappainta on painettu, ja toimitaan sen mukaisesti
	if nappain == "escape" then
		love.event.quit()
		
	-- Vaihdetaan lumisade-modi
	elseif nappain == "return" then
		TEsound.play("media/aanet/tehosteet/white_noise.ogg")
		lumisade = true
	end

end
