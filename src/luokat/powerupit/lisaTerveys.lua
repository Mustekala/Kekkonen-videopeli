lisaTerveys = { kesto = 0, vanhaArvo, anim = newAnimation(kuvat["heal.png"],32,32,0.1,4)}
numero = 0

--Annetaan lisaterveytta pelaajalle
function lisaTerveys:kayta( pelaajaNumero )
	if not self.kaytossa then
		TEsound.play(TEHOSTE_POLKU.."lisaTerveys.ogg")
		self.kaytossa = true
		self.kesto = 0.8
		numero = pelaajaNumero
		self.vanhaArvo = pelaajat[numero].terveys
		pelaajat[numero].terveys = pelaajat[numero].terveys + 50
	end		
end

function lisaTerveys:update(dt)
	self.kesto = self.kesto - dt
	if self.kesto < 0 then
		self.kaytossa = false
	end
	
	if self.kaytossa then
		self.anim:update(dt)
	end	
end

function lisaTerveys:draw()
	if self.kaytossa then
		self.anim:draw(pelaajat[numero].x- 10, pelaajat[numero].y- 20)
	end	
end