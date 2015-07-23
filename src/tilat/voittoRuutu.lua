--[[
	Pelin viimeinen ruutu, jossa ainut vaihtoehto escin lisaksi on enter -> avausvalikot
--]]


-- Luodaan itse voittoRuutu-tila pelille
voittoRuutu = {

kukaVoitti = "es"

}

function voittoRuutu:init()
  torvi_anim = newAnimation(kuvat["party_horn.png"], 129, 127, 0.15, 8)
  torvi_anim:setMode("once")
end

function voittoRuutu:enter(wanhaState , numero)

	torvi_anim:reset() --resetoidaan animaatio
	torviAjastin = 0 --Ajastin animaatiolle
	--Pysaytetaan  taustaaanet 
	TEsound.stop("tausta")
	TEsound.stop("musiikki", true )
	
	TEsound.play("media/aanet/tehosteet/party_horn.ogg") 
	
	self.kukaVoitti = "Pelaaja "..numero
	print(self.kukaVoitti.." voitti")
end

function voittoRuutu:update( dt )
	torviAjastin = torviAjastin + dt
	if torviAjastin > 0.6 then
		torvi_anim:update(dt)
	end	
end


function voittoRuutu:draw()
	
	-- Piiretaan tausta
	love.graphics.draw( kuvat[ "ukk_tausta_party.png" ], 0, 0 )
	torvi_anim:draw(540, 195, 0, -1, 1) --Piiretaan torvi

	-- Piirretaan suuri nimi/title
	love.graphics.print(self.kukaVoitti.. " voitti", 10, 200, 0, 1.1, 1.1 )

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
