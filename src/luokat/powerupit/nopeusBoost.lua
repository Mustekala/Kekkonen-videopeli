nopeusBoost = { kesto = 0, vanhaArvo, kaytossa = false }
numero = 0

--Otetaan nopeusboost kayttoon pelaajalle
function nopeusBoost:kayta( pelaajaNumero )
  if not self.kaytossa then
	self.kaytossa = true
	numero = pelaajaNumero

	self.kesto = 5
	self.vanhaArvo = pelaajat[numero].juoksuNopeus
	pelaajat[numero].juoksuNopeus = pelaajat[numero].juoksuNopeus + 100
	print("Nopeutta boostattu")
		
  end	
end

function nopeusBoost:update(dt)
	--Jos kaytossa, laskuri laskee
	if self.kaytossa then
		self.kesto = self.kesto - dt
		if self.kesto < 0 then --Nopeusboost loppuu
			print("Nopeusboost loppu")
			pelaajat[numero].juoksuNopeus = self.vanhaArvo
			self.vanhaArvo = 0 --Resetoidaan vanha arvo
			self.kaytossa = false
		end	
	end	
end

function nopeusBoost:draw()
	if self.kaytossa then
    --Animaatio
	end
end