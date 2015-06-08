--[[
Jetpackin avulla pelaaja voi lentaa. Tama toteutetaan ottamalla hypyn rajoitus ilmassa pois.
]]

jetpack = { 
	kesto = 5,
	vanhaArvo,
	kaytossa = false, 
	anim_idle = newAnimation(kuvat["jetpack_idle.png"], 32, 32, 0.2, 2), 
	anim_kiihdytys = newAnimation(kuvat["jetpack_kiihdytys.png"], 32, 32, 0.2, 2)
}
numero = 0

--Otetaan jetpack kayttoon pelaajalle
function jetpack:kayta( pelaajaNumero )
  if not self.kaytossa then
	
	TEsound.play(TEHOSTE_POLKU.."jetpack.ogg")
    self.nykAnim = self.anim_idle --Animaatio
	self.kaytossa = true		  --Onko kaytossa
	numero = pelaajaNumero		  --Kayttava pelaaja
	self.kesto = 15			 	  --Kesto
	self.vanhaArvo = pelaajat[numero].yNopeusMax
	pelaajat[numero].yNopeusMax = 300 --Muutetaan maksiminopeutta jolla pelaaja voi liikkua y-akselilla
		
  end	
end

function jetpack:update(dt)
	--Jos kaytossa, laskuri laskee
	if self.kaytossa then
	
		if pelaajat[numero].tila == "hyppy" then
			self.nykAnim = self.anim_kiihdytys
		else 	
			self.nykAnim = self.anim_idle
		end
		self.nykAnim:update(dt)
		pelaajat[numero].voiHypata = true --Voi hypata myos ilmassa
		self.kesto = self.kesto - dt
		if self.kesto < 0 then --jetpack loppuu
			print("jetpack loppui")
			self.kaytossa = false
			pelaajat[numero].voiHypata = false
			pelaajat[numero].yNopeusMax = self.vanhaArvo
		end	
		
	end		
end

function jetpack:draw()
	if self.kaytossa then
		self.nykAnim:draw(pelaajat[numero].x + 30 * pelaajat[numero].animSuunta , pelaajat[numero].y-40, 0, -2 * pelaajat[numero].animSuunta, 2)
	end
end