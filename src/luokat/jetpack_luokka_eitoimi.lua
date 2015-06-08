--[[
Jetpackin avulla pelaaja voi lentaa. Tama toteutetaan ottamalla hypyn rajoitus ilmassa pois.
]]

jetpack = {}
jetpack.__index = jetpack



function jetpack:luo()
	
	local olio = {
		numero = 0,
		kesto = 15,
		vanhaArvo, 
		kaytossa = false ,
		anim_idle = newAnimation(kuvat["jetpack_idle.png"], 32, 32, 0.2, 2), 
		anim_kiihdytys = newAnimation(kuvat["jetpack_kiihdytys.png"], 32, 32, 0.2, 2),	
	}
	setmetatable( olio, { __index = jetpack } )
	
	print("luotiin jetpack-olio "..numero)

	return olio
	
end

--otetaan jetpack kayttoon pelaajalle
function jetpack:kayta( pelaajaNumero )
	
	jetpack = self:luo()
	TEsound.play(TEHOSTE_POLKU.."jetpack.ogg")
	jetpack.nykAnim = jetpack.anim_idle --Animaatio
	jetpack.kaytossa = true		  --Onko kaytossa
	jetpack.numero = pelaajaNumero		  --Kayttava pelaaja
	jetpack.vanhaArvo = _G[pelaajat[jetpack.numero].hahmo].yNopeusMaksimi
	pelaajat[jetpack.numero].yNopeusMax = 300 --Muutetaan maksiminopeutta jolla pelaaja voi liikkua y-akselilla
	print(jetpack.vanhaArvo)
	Timer.add(jetpack.kesto,
	function() 
		pelaajat[jetpack.numero].yNopeusMax = jetpack.vanhaArvo
		jetpack.kaytossa = false
		pelaajat[jetpack.numero].voiHypata = false 
	end
	)

end

function jetpack:update(dt)
	--Jos kaytossa, laskuri laskee
	if jetpack.kaytossa then
	
		if pelaajat[jetpack.numero].tila == "hyppy" then
			jetpack.nykAnim = jetpack.anim_kiihdytys
		else 	
			jetpack.nykAnim = jetpack.anim_idle
		end
		jetpack.nykAnim:update(dt)
		pelaajat[jetpack.numero].voiHypata = true --Voi hypata myos ilmassa
		
	end		
end

function jetpack:draw()
	if jetpack.kaytossa then
		jetpack.nykAnim:draw(pelaajat[jetpack.numero].x + 30 * pelaajat[jetpack.numero].animSuunta , pelaajat[jetpack.numero].y-40, 0, -2 * pelaajat[jetpack.numero].animSuunta, 2)
	end
end
