--[[
Jetpackin avulla pelaaja voi lentaa. Tama toteutetaan ottamalla hypyn rajoitus ilmassa pois.
]]

jetpack = { kesto = 5, vanhaArvo, kaytossa = false }
numero = 0

--Otetaan jetpack kayttoon pelaajalle
function jetpack:kayta( pelaajaNumero )
  if not self.kaytossa then
	self.kaytossa = true
	numero = pelaajaNumero
	self.kesto = 10
	self.vanhaArvo = pelaajat[numero].yNopeusMax
	pelaajat[numero].yNopeusMax = 300 --Muutetaan maksiminopeutta jolla pelaaja voi liikkua y-akselilla
		
  end	
end

function jetpack:update(dt)
	--Jos kaytossa, laskuri laskee
	if self.kaytossa then
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
		love.graphics.circle("fill", pelaajat[numero].x, pelaajat[numero].y, 30)
	end
end