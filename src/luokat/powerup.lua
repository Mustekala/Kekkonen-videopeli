--[[
	Powerupit muuttavat jotain sen poimivan pelaajan ominaisuuksista. Aika pahasti viela vaiheessa.
]]--

powerup = {} 
kaikkiPowerupit = {}	--Lista kaikista powerupeista
kaytetytPowerupit = {}
nakyvaPowerup = {nimi = "jetpack" , x = 0, y = 0, xNopeus = 1, yNopeus = 1, onNakyva = false, onKaytetty = false} --Talla hetkella nakyva powerup


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
	nakyvaPowerup.onKaytetty = true
	print("Pelaaja "..pelaajaNumero.." sai powerupin "..nimi)
	_G[nimi]:kayta(pelaajaNumero)
	table.insert(kaytetytPowerupit, _G[nimi])
	print("Poweruppeja kaytetty yhteensa: "..table.getn(kaytetytPowerupit))
end

--Lisaa powerup nakyviin
function powerup:lisaa(nimi)
	if not nakyvaPowerup.onNakyva then	
		nakyvaPowerup.onKaytetty = false
		nakyvaPowerup.y = -200
		nakyvaPowerup.x =  math.random(10, 600)
		nakyvaPowerup.nimi = nimi
		nakyvaPowerup.onNakyva = true
	end
end

--Lisaa random powerupin kaikkiPowerupit-listalta
function powerup:lisaaRandom()	
	if not nakyvaPowerup.onNakyva and not _G[nakyvaPowerup.nimi].kaytossa then	
		randomPowerup = kaikkiPowerupit[math.random(1,table.getn(kaikkiPowerupit))]
		nakyvaPowerup.nimi = randomPowerup
		nakyvaPowerup.y = -200	
		nakyvaPowerup.yNopeus = 0	
		nakyvaPowerup.x =  math.random(0, 900)
		nakyvaPowerup.xNopeus =  math.random(-2, 2)
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
		if self:tarkistaTormays(nakyvaPowerup.x, nakyvaPowerup.y + 20) == "lattia" then	
			nakyvaPowerup.yNopeus = nakyvaPowerup.yNopeus * -0.7	
		elseif self:tarkistaTormays(nakyvaPowerup.x, nakyvaPowerup.y + 20) == "seina" then
			nakyvaPowerup.xNopeus = nakyvaPowerup.xNopeus * -0.7
		else
			nakyvaPowerup.yNopeus = nakyvaPowerup.yNopeus + 0.02	
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
	
	--Nayta teksti powerupista
	if nakyvaPowerup.onKaytetty then
		Timer.add(2, function() nakyvaPowerup.onKaytetty = false end)
		love.graphics.pop()
			love.graphics.printf("POWERUP: "..nakyvaPowerup.nimi, 100, 150, 600, "center")
		love.graphics.push()
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

	local laatta2 = nykyinenTaso("Seinat")(laattaX, laattaY - 1)
	
    if not (laatta == nil) then
		print("OSUMA")
		if not (laatta2 == nil) then --Jos viereinen laatta on olemassa, seina
			print("seina")
			return "seina"			
		else 
			print("lattia")
			return "lattia" --Muuten lattia
		end	
	end
	
end
