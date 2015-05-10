--[[
	Powerupit muuttavat jotain sen poimivan pelaajan ominaisuuksista. Aika pahasti viela vaiheessa.
]]--

powerup = {} 
kaikkiPowerupit = {}	--Lista kaikista powerupeista
nakyvaPowerup = {nimi = "" , x = 0, y = 0, xNopeus = 1, yNopeus = 1, onNakyva = false} --Talla hetkella nakyva powerup

function powerup:lataa()
	
	--Ladataan kaikki powerupit
	for _, nykyinen in ipairs( love.filesystem.getDirectoryItems( POWERUP_POLKU )) do
		local nykyinenPowerup = string.gsub(nykyinen,".lua","")
		--Ladataan powerupin koodi
		print("ladattiin powerup:"..nykyinenPowerup)
		require (POWERUP_POLKU .. nykyinenPowerup) 
		table.insert(kaikkiPowerupit, nykyinenPowerup)
	end
	powerup_anim = newAnimation(kuvat["powerup.png"],200,200,0.05,8)
	powerup_anim:setMode("bounce")
end

--Kayta powerup pelaajalle	
function powerup:kayta( nimi, pelaajaNumero )
	print("Pelaaja "..pelaajaNumero.." sai powerupin "..nimi)
	_G[nimi]:kayta(pelaajaNumero)
end

--Lisaa powerup nakyviin
function powerup:lisaa(nimi)
	if not nakyvaPowerup.onNakyva then		
		nakyvaPowerup.y = -200
		nakyvaPowerup.x =  math.random(10, 600)
		nakyvaPowerup.nimi = nimi
		nakyvaPowerup.onNakyva = true
	end
end

--TODO korjaa kahden saman powerupin ongelmat, tai poista mahdollisuus siihen
--Lisaa random powerupin kaikkiPowerupit-listalta
function powerup:lisaaRandom()	
	if not nakyvaPowerup.onNakyva then	
		randomPowerup = kaikkiPowerupit[1]
		while nakyvaPowerup.nimi == randomPowerup do --Ei kahta samaa poweruppia perakkain
			randomPowerup = kaikkiPowerupit[math.random(1, table.getn(kaikkiPowerupit))]
		end	
		nakyvaPowerup.nimi = randomPowerup
		nakyvaPowerup.y = -100	
		nakyvaPowerup.yNopeus = 0	
		nakyvaPowerup.x =  math.random(10, 600)
		nakyvaPowerup.xNopeus =  math.random(-2,2)
		nakyvaPowerup.onNakyva = true
	end
end

function powerup:update( dt )

	--Paivittaa kaikki powerupit 
	for _, nyk in ipairs (kaikkiPowerupit) do
		_G[nyk]:update(dt)
	end
	--Paivittaa nakyvan(poimattavan) powerupin
	if nakyvaPowerup.onNakyva then
		powerup_anim:update(dt)
		nakyvaPowerup.y = nakyvaPowerup.y + nakyvaPowerup.yNopeus
		nakyvaPowerup.x = nakyvaPowerup.x + nakyvaPowerup.xNopeus
		if not self:tarkistaTormays(nakyvaPowerup.x, nakyvaPowerup.y+20) then		
			nakyvaPowerup.yNopeus = nakyvaPowerup.yNopeus + 0.1		
		else
			nakyvaPowerup.yNopeus = nakyvaPowerup.yNopeus * -0.7
		end
		--Poistetaan pudonneet
		if nakyvaPowerup.y > 1000 then
			nakyvaPowerup.onNakyva = false			
		end
		
		--Tunnistaa pelaajan powerupin lahella
		for _, pelaaja in ipairs (pelaajat) do 
		
			if math.isAbout(pelaaja.x, nakyvaPowerup.x, 25) and math.isAbout(pelaaja.y, nakyvaPowerup.y, 25) then
				self:kayta(nakyvaPowerup.nimi, pelaaja.numero)
				nakyvaPowerup.onNakyva = false
			end
			
		end
	end	
	
end

function powerup:draw()
	--Piirra poweruppien efektit, maaritellaan powerpin omassa koodissa 
	for _, nyk in ipairs (kaikkiPowerupit) do
		_G[nyk]:draw() 
	end
	
	--Piirra nakyva(poimattava) powerup
	if nakyvaPowerup.onNakyva then
		powerup_anim:draw(nakyvaPowerup.x, nakyvaPowerup.y, 0, 0.3, 0.3, 100, 100)
	end
end

--Tarkistaa poweruppien tormauksen seiniin 
--TODO korjaa sivuttaisen seinan sisaan lagaaminen
function powerup:tarkistaTormays(x, y)

    local kerros = nykyinenTaso.layers["seinat"]

	local laattaX, laattaY = math.floor(x / 32), math.floor(y / 32)
   
    local laatta = nykyinenTaso("Seinat")(laattaX, laattaY)

    return not(laatta == nil)
	
end
