--[[
	Vihrea: nopea, ei lyo niin kovaa
--]]


kekkonen_green = {

	xNopeusMaksimi = 400,
	yNopeusMaksimi = 1000,
	
	--Hyokkausten voima 
	lyontiVahinko = 7, --Vahingon maara
	heittoVoima = 0.8, --Heiton voiman kerroin
	
	kestavyys = 100,

	juoksuNopeus = 300,
	
	hyppyNopeus = -650,

	-- isku, torjunta, heitto, potku, heittoase
	
}

function kekkonen_green:lataaAnimaatiot()

	self.kavely_anim = newAnimation(kuvat["kekkonen_kavely_green.png"],32,61,0.06,7)

	self.lyonti_anim = newAnimation(kuvat["kekkonen_lyo_oikea_green.png"],42,64,0.045,7)
	self.lyonti_anim:setMode("once")

	self.critLyonti_anim = newAnimation(kuvat["kekkonen_lyo_vasen_green.png"],42,64,0.045,7)
	self.critLyonti_anim:setMode("once")

	self.heitto_anim = newAnimation(kuvat["kekkonen_heitto_green.png"],40,65,0.05,10)
	self.heitto_anim:setMode("once")

	self.paikallaan_anim = newAnimation(kuvat["kekkonen_paikallaan_green.png"],42,64,0.5,2)

	self.torjunta_anim = newAnimation(kuvat["kekkonen_torjunta_green.png"],32,61,0.04,6)
	self.torjunta_anim:setMode("once")

	self.putoaminen_anim = newAnimation(kuvat["kekkonen_putoaminen_green.png"],35,62,0.2,2)

	self.laskeutuminen_anim = newAnimation(kuvat["kekkonen_laskeutuminen_green.png"],42,65,0.05,6)
    self.laskeutuminen_anim:setMode("once")

	self.hyppy_anim = newAnimation(kuvat["kekkonen_hyppy_green.png"],34,65,0.05,6)
	self.hyppy_anim:setMode("once")

	self.vahinko_anim = newAnimation(kuvat["kekkonen_taintunut_green.png"],32,62,0.1,7)
	self.vahinko_anim:setMode("bounce")
	
	self.kaantyminen_anim = newAnimation(kuvat["kekkonen_kaantyy_green.png"],34,61,0.05,3)
	self.kaantyminen_anim:setMode("once")
	
	self.kuolema_anim = newAnimation(kuvat["kekkonen_kuolema_green.png"],32,62,0.15,6)
	self.kuolema_anim:setMode("once")
	
	self.respawn_anim = newAnimation(kuvat["kekkonen_respawn_green.png"],32,61,0.1,18)
	self.respawn_anim:setMode("once")
	
	print("Animaatiot ladattu: kekkonen green")
end

function kekkonen_green:enter()

end

function kekkonen_green:update(dt,tila,suunta)
	

end

function kekkonen_green:draw(nykAnim, x, y ,suunta)
	


end


function kekkonen_green:haeOsumaLaatikot( x, y )

	return {
		{ x - 10, y - 0, h = 11, w = 13 },
		{ x - 1, y - 11, h = 18, w = 30 },
		{ x - 6, y - 29, h = 12, w = 20 },
		{ x - 3, y - 41, h = 20, w = 26 }
	}

end
