--[[
	Pelin viimeinen ruutu, jossa ainut vaihtoehto escin lisaksi on enter -> avausvalikot
--]]


-- Luodaan itse voittoRuutu-tila pelille
voittoRuutu = {

kukaVoitti = "es"

}

function voittoRuutu:init()
	
	--TEsound.playLooping("media/aanet/musiikki/voittoRuutu.ogg", "musiikki")
	print("Loopataan voittomusiikki")

end

function voittoRuutu:enter(wanhaState , numero)
	
	self.kukaVoitti = "Pelaaja "..numero
end

function voittoRuutu:update( dt )

end


function voittoRuutu:draw()
	
	-- Piiretaan tausta
	love.graphics.draw( kuvat[ "ukk_tausta.png" ], 0, 0 )

	-- Piirretaan suuri nimi/title
	love.graphics.print(self.kukaVoitti.. " voitti", 20, 200, 0, 1.5, 1.5 )

	love.graphics.print( "Paina Enter jatkaaksesi \ntai Esc lopettaaksesi", 60, 300, 0, 0.6, 0.6 )
	

end


function voittoRuutu:keypressed( nappain )

	-- Tarkistetaan mita nappainta on painettu, ja toimitaan sen mukaisesti
	if nappain == "escape" then
		love.event.quit()
		
	-- Vaihdetaan paavalikko
	elseif nappain == "return" then
		TEsound.play("media/aanet/tehosteet/menuclick.ogg")
		print( "Paavalikko")
		Gamestate.switch( valikko, self )
	end

end
