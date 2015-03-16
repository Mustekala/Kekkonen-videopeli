--[[
	Sininen:default
--]]


kekkonen_blu = {

	xNopeusMaksimi = 400,
	yNopeusMaksimi = 1000,

	--Hyokkausten voima 
	lyontiVahinko = 10, --Vahingon maara
	heittoVoima = 1, --Heittovoiman kerroin
	
	kestavyys = 100,

	juoksuNopeus = 200,
	
	hyppyNopeus = -625,

	-- isku, torjunta, heitto, potku, heittoase
	
}

function kekkonen_blu:lataaAnimaatiot()

	self.kavely_anim = newAnimation(kuvat["kekkonen_kavely_blu.png"],33,61,0.07,7)

	self.lyonti_anim = newAnimation(kuvat["kekkonen_lyonti_blu.png"],42,64,0.045,10)

	self.heitto_anim = newAnimation(kuvat["kekkonen_heitto_blu.png"],40,65,0.04,7)
	self.heitto_anim:setMode("bounce")

	self.paikallaan_anim = newAnimation(kuvat["kekkonen_paikallaan_blu.png"],42,64,0.5,2)

	self.torjunta_anim = newAnimation(kuvat["kekkonen_torjunta_blu.png"],32,61,0.04,6)
	self.torjunta_anim:setMode("once")

	self.putoaminen_anim = newAnimation(kuvat["kekkonen_putoaminen_blu.png"],35,62,0.2,2)

	self.laskeutuminen_anim = newAnimation(kuvat["kekkonen_laskeutuminen_blu.png"],42,65,0.05,6)
    self.laskeutuminen_anim:setMode("once")

	self.hyppy_anim = newAnimation(kuvat["kekkonen_hyppy_blu.png"],34,65,0.04,6)
	self.hyppy_anim:setMode("once")

	self.vahinko_anim = newAnimation(kuvat["kekkonen_taintunut_blu.png"],32,62,0.1,7)
	self.vahinko_anim:setMode("bounce")
	
	self.kaantyminen_anim = newAnimation(kuvat["kekkonen_kaantyy_blu.png"],34,61,0.05,3)
	self.kaantyminen_anim:setMode("once")
	
	print("Animaatiot ladattu: kekkonen")
end

function kekkonen_blu:enter()

end

function kekkonen_blu:update(dt,tila,suunta)
	

end

function kekkonen_blu:draw(nykAnim, x, y ,suunta)
	


end


function kekkonen_blu:haeOsumaLaatikot( x, y )

	return {
		{ x - 10, y - 0, h = 11, w = 13 },
		{ x - 1, y - 11, h = 18, w = 30 },
		{ x - 6, y - 29, h = 12, w = 20 },
		{ x - 3, y - 41, h = 20, w = 26 }
	}

end
