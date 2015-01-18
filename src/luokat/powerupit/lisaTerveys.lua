lisaTerveys = { kesto = 0, vanhaArvo}
numero = 0

--Annetaan lisaterveytta pelaajalle
function lisaTerveys:kayta( pelaajaNumero )
	numero = pelaajaNumero
	self.vanhaArvo = pelaajat[numero].terveys
	pelaajat[numero].terveys = pelaajat[numero].terveys + 50
end

function lisaTerveys:update(dt)
	--Ei tarvitse paivittaa
end

function lisaTerveys:draw()
	--Ei edektia
end