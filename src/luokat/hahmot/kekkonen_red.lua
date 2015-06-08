--[[
	Punainen: hidas, lyo kovaa, heittaa kovaa
--]]


kekkonen_red = {

	xNopeusMaksimi = 400,
	yNopeusMaksimi = 1000,

	kestavyys = 150,
	--Hyokkausten voima 
	lyontiVahinko = 15, --Vahingon maara
	heittoVoima = 1.3, --Heittovoiman kerroin
	
	juoksuNopeus = 135,
	
	hyppyNopeus = -625,

	-- isku, torjunta, heitto, potku, heittoase
	
}

function kekkonen_red:lataaAnimaatiot()

	self.kavely_anim = newAnimation(kuvat["kekkonen_kavely_red.png"],32,61,0.08,7)

	self.lyonti_anim = newAnimation(kuvat["kekkonen_lyo_oikea_red.png"],42,64,0.055,7)
	self.lyonti_anim:setMode("once")

	self.critLyonti_anim = newAnimation(kuvat["kekkonen_lyo_vasen_red.png"],42,64,0.055,7)
	self.critLyonti_anim:setMode("once")
	
	self.heitto_anim = newAnimation(kuvat["kekkonen_heitto_red.png"],40,65,0.05,10)
	self.heitto_anim:setMode("once")

	self.paikallaan_anim = newAnimation(kuvat["kekkonen_paikallaan_red.png"],42,64,0.5,2)

	self.torjunta_anim = newAnimation(kuvat["kekkonen_torjunta_red.png"],32,61,0.025,6)
	self.torjunta_anim:setMode("once")

	self.putoaminen_anim = newAnimation(kuvat["kekkonen_putoaminen_red.png"],35,62,0.2,2)

	self.laskeutuminen_anim = newAnimation(kuvat["kekkonen_laskeutuminen_red.png"],42,65,0.05,6)
    self.laskeutuminen_anim:setMode("once")

	self.hyppy_anim = newAnimation(kuvat["kekkonen_hyppy_red.png"],34,65,0.05,6)
	self.hyppy_anim:setMode("once")

	self.vahinko_anim = newAnimation(kuvat["kekkonen_taintunut_red.png"],32,62,0.1,7)
	self.vahinko_anim:setMode("bounce")
	
	self.kaantyminen_anim = newAnimation(kuvat["kekkonen_kaantyy_red.png"],34,61,0.05,3)
	self.kaantyminen_anim:setMode("once")
	
	self.kuolema_anim = newAnimation(kuvat["kekkonen_kuolema_red.png"],32,62,0.15,6)
	self.kuolema_anim:setMode("once")
	
	self.respawn_anim = newAnimation(kuvat["kekkonen_respawn_red.png"],32,61,0.1,18)
	self.respawn_anim:setMode("once")
	
	print("Animaatiot ladattu: kekkonen red")
end

function kekkonen_red:enter()

end

function kekkonen_red:update(dt,tila,suunta)
	

end

function kekkonen_red:draw(nykAnim, x, y ,suunta)
	


end


function kekkonen_red:haeOsumaLaatikot( x, y )

	return {
		{ x - 10, y - 0, h = 11, w = 13 },
		{ x - 1, y - 11, h = 18, w = 30 },
		{ x - 6, y - 29, h = 12, w = 20 },
		{ x - 3, y - 41, h = 20, w = 26 }
	}

end
