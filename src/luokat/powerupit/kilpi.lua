--[[
Kilpi tekee pelaajasta vahingoittumattoman hetkeksi
TODO parempi animaatio
]]--

kilpi = { kesto = 0, vanhaArvo, kaytossa = false, anim = newAnimation(kuvat["kilpi.png"], 32, 64, 0.1, 6) } 
numero = 0

--Otetaan kilpi kayttoon pelaajalle
function kilpi:kayta( pelaajaNumero )
  if not self.kaytossa then
	
	--TEsound.play(TEHOSTE_POLKU.."kilpi.ogg")
	
	self.kaytossa = true
	numero = pelaajaNumero

	self.kesto = 10

	print("Pelaajalla "..pelaajaNumero.." on kilpi")
		
  end	
end

function kilpi:update(dt)
	--Jos kaytossa, laskuri laskee
	if self.kaytossa then
		self.anim:update(dt)
		self.kesto = self.kesto - dt
		pelaajat[numero].vahinkoAjastin = 1
		if self.kesto < 0 then --kilpi loppuu
			print("kilpi loppu")
			self.kaytossa = false
		end	
	end	
end

function kilpi:draw()
	if self.kaytossa then
      self.anim:draw(pelaajat[numero].x - 15 + (20 * pelaajat[numero].animSuunta), pelaajat[numero].y - 50)
	end
end