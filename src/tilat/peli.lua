--[[
	liturgi.laula( "Herra olkoon teidan kanssanne" )
	seurakunta.laula( "Niin myos sinun henkesi kanssa." )
--]]


peli = {}

function peli:init()
			
	x  = 300
	y = 300
	r = 1

	painovoima = 20

	onkoPaussi = false

end

function peli:enter( aiempi, tasonNimi, pelaajaMaara, elamienMaara, hahmot, bottienMaara)
	
	pelaajat = {}
	
	print("Aiempi state:"..aiempi.nimi) 
	
	intro = false
	if aiempi.nimi == "intro" then
		intro = true
	end
	
	TEsound.stop("musiikki")

	--Sumu. Alle voi lisata ifin kaikille sumua kayttaville kartoille
	sumu = {tila = false}
	if aiempi.nimi == "tunarit" then --Kekkonen on vihainen: punainen sumu, sade, musiikki
		sumu.kuva = kuvat["red_layer.png"]
		sumu.tila = true
		sataako = true
		TEsound.playLooping(MUSIIKKI_POLKU.."/kekkonenOnVihainen.ogg", "musiikki")
	end	
	
	tasoNimi = tasonNimi

   if not peliAlkanut then
	
	nykKamera = "tavallinen"
	
	kulunutAika = 0 --Ajastin pelin kulumiselle
	
	nykyinenTaso = loader.load(tasonNimi..".tmx")
	nykyinenTaso:setDrawRange(0, 0, 2000, 960)
	
	pelaajienMaara = pelaajaMaara
		
	maxElamat = elamienMaara
	
	--[[
	for u, i in pairs(tormayskohdat.data) do
		print('\n')
		print(u)
		print('----')
		print(i)
		print('\n')
	end
	--]]

	peli:luoPelaajat(hahmot, bottienMaara)

	peliAlkanut=true
		
   end
	testiajastin=0
	  
	--Taustaaanet, musiikki
	
			
	--Sade. Karttaan voi lisata layerin sateelle
	if nykyinenTaso.layers["Sade"] == nil then
		sataako = false
	else		
		sataako = true
	end
	
	if sataako then
		sade:uusi(nykyinenTaso, -500, -500, 1500, 5)
		TEsound.playLooping(AANI_POLKU.."/ymparisto/sade.ogg", "tausta")
	end	
end


function peli:update( dt )
    
	Timer.update(dt) --Paivitetaan mahdolliset ajastimet
	
	if peliAlkanut then
			
		kulunutAika = kulunutAika + dt --Ajastin pelin kulumiselle
		
		if kulunutAika < 3 then --Alkulaskenta (peli:draw)
			
			for _, pelaaja in pairs( pelaajat ) do --Pelaajat eivat voi liikkua pelin alussa
				pelaaja.voiLiikkua = false
			end
			
		end
		
		--Paivitetaan powerupit
		powerup:update(dt)
		--Lisataan random powerup random aikoihin, valittu yleisyys vaikuttaa 
		if math.random(0, 2000 / powerupYleisyys) == 0 then powerup:lisaaRandom() end
		
		if sataako then
			sade:update(dt)
		end
		
		--Jos kameran tila on kuolema, pelaajat eivat voi liikkua
		if nykKamera=="kuolema" then
			for _, pelaaja in pairs( pelaajat ) do
				pelaaja:pysahdy( )
			end
		else --Muuten voi liikkua
			self:liikutaPelaajat()
		end
		
		--Paussi jos ikkuna taustalla
		if not love.window.hasFocus( ) then
			Gamestate.push(paussivalikko)
		end 
		
		--Huono vahikotunnistus: jos pelaajat lahekkain, kontakti. Tarkempi maaritys pelaaja-luokassa
		if math.isAbout(pelaajat[1].x,pelaajat[2].x, 60) and math.isAbout(pelaajat[2].y, pelaajat[1].y, 32) then 
			for _, pelaaja in pairs( pelaajat ) do		    
				local toinen = pelaaja.numero%2+1	
				pelaaja:kontakti(pelaajat[toinen])
			end
		end
			
		for _, pelaaja in pairs( pelaajat ) do

			pelaaja:update( dt, painovoima )

		end
		
		--Kamerat
		if nykKamera == "tavallinen" then
			camera:liikkuvaKamera(pelaajat[1].x,pelaajat[1].y,pelaajat[2].x,pelaajat[2].y)
		
		elseif nykKamera == "Shake" then
			camera:shake(pelaajat[1].x,pelaajat[1].y,pelaajat[2].x,pelaajat[2].y)
		
		elseif nykKamera == "kuolema" then
			camera:kuolemaKamera(pelaajat[1].x,pelaajat[1].y,pelaajat[2].x,pelaajat[2].y)
			  
			if camera:kuolemaKamera(pelaajat[1].x,pelaajat[1].y,pelaajat[2].x,pelaajat[2].y)==true then		  
				nykKamera="tavallinen"
				print("Kamera:"..nykKamera)
			end
			
		--Mahdollinen voittajakamera
		elseif nykKamera == "voittajaKamera" then			
			camera:voittajaKamera(voittaja.x, voittaja.y)				
		
		end
		
		--Paivitetaan animaatiot
			
		for i, pelaaja in pairs ( pelaajat ) do	
			pelaaja.nykAnim:update(dt)
		end	
		
    end
end


	--Liikkuminen, pitaisi siirtaa varmaankin pelaaja-luokkaan
function peli:liikutaPelaajat()		
	for i, pelaaja in pairs ( pelaajat ) do	
		--Ei botti, pelaaja ohjaa nappaimistolla
		if not pelaaja.onBotti and not pelaaja.kuollut then
		
			if love.keyboard.isDown(pelaajienKontrollit[i].YLOS) then
	
				pelaaja:hyppaa()	
		
			end
			
			if love.keyboard.isDown(pelaajienKontrollit[i].OIKEALLE) and not love.keyboard.isDown(pelaajienKontrollit[i].VASEMMALLE) then
			
				pelaaja:liikuOikealle()
			
			elseif love.keyboard.isDown(pelaajienKontrollit[i].VASEMMALLE) and not love.keyboard.isDown(pelaajienKontrollit[i].OIKEALLE)  then
			
				pelaaja:liikuVasemmalle()
			
			elseif love.keyboard.isDown(pelaajienKontrollit[i].LYONTI) and pelaaja.voiLyoda then
				
				pelaaja:lyonti()
			
		    elseif love.keyboard.isDown(pelaajienKontrollit[i].TORJUNTA) then
			 
				pelaaja:torjunta()
				
			elseif love.keyboard.isDown(pelaajienKontrollit[i].HEITTOASE) and pelaaja.voiHeittaa then
			 
				pelaaja:heitto()
				
			else
			
				pelaaja:pysahdy()
				
			end
			
	    --Botti ohjaa
	    else 
			botti:update()
		end
	end 
end

function peli:draw()

    --local taso = _G[tasoNimi].attribute
	
	--Dynaaminen tausta
	local taustaZoom = 2 + 0.1/camera.scaleX 
	local taustaX = camera._x *-1 /5 -100 --Taustat liikkuvat kameran mukana, mutta maltillisemmin
	local taustaY = camera._y *-1 /10 -100
	--Takaosa
	love.graphics.draw(kuvat[tasoNimi.."_tausta_2.png"], taustaX / 2, taustaY / 2, 0, taustaZoom, taustaZoom, 50, 25) --Tason tausta piirtyy erikseen		
	--Etuosa
	love.graphics.draw(kuvat[tasoNimi.."_tausta.png"], taustaX, taustaY, 0, taustaZoom, taustaZoom, 50, 25) --Tason tausta piirtyy erikseen	
	
	camera:set() --Liikkuva kamera	
		
	if sataako then
		sade:draw()
	end
		
	nykyinenTaso:draw() --Piirtaa tason (ATL)
	
	for _, pelaaja in pairs( pelaajat ) do
		pelaaja:draw()	
		if debugMode then
			love.graphics.circle("fill", pelaaja.x, pelaaja.y, 10) --Piirtaa ympyran pelaajan kordinaatteihin
		end
	end
	
	powerup:draw()
	
	if sumu.tila==true then
		love.graphics.draw(sumu.kuva, -500, -500, 0, 4, 4)
	end
	
	camera:unset() --Ei enaa liikkuva kamera	
	
	if kulunutAika < 4 then --Alkulaskenta
		if kulunutAika < 1 then
			love.graphics.print(3, 350, 200, 0, 2)
		elseif kulunutAika < 2 then
			love.graphics.print(2, 350, 200, 0, 2)
		elseif kulunutAika < 3 then
			love.graphics.print(1, 350, 200, 0, 2)
		elseif kulunutAika < 3.9 then
			love.graphics.print("GO!", 350, 200, 0, 2)
			if estaSoitto ~= true then --Soita vain kerran
				TEsound.play(TEHOSTE_POLKU.."Go!.ogg", "Go")
				estaSoitto = true
			end
		else
			estaSoitto = false
		end	
	end
	
	if debugMode==true then

		love.graphics.print(pelaajat[1].tila, 0,0,0,0.5,0.5)
		love.graphics.print(pelaajat[2].tila, 600,0,0,0.5,0.5)
		love.graphics.print("x: "..math.ceil(pelaajat[1].x) .. " y: "..math.ceil(pelaajat[1].y), 0,50,0,0.5,0.5)
		love.graphics.print("x: "..math.ceil(pelaajat[2].x) .. " y: "..math.ceil(pelaajat[2].y), 600,50,0,0.5,0.5)
		love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 300, 10)
		
	end

	if intro then --Jos osa introa, lopeta peli viidessa sekunnissa
		if kulunutAika > 5 then
			print("Intro loppu")
			Gamestate.switch( avausRuutu )
		end
	end
	
end


function peli:keypressed( nappain )
		
	if nappain == "escape" then
		
		Gamestate.push(paussivalikko,"peli")
		
		print("Paussivalikko")
	
	elseif nappain == "f1" then
		
		Gamestate.push(apuva, "peli")
		
	end
	
		--Debug:numlock pakottaa sateen (aika turha)  
    if nappain == "numlock" and debugMode then
		sataako = not sataako
		if sataako then  sade:uusi(nykyinenTaso, -500, -500, 1500, 5) end
		print("pakotetaan sade:"..tostring(sataako))
	end
  
end

function peli:asetaPaussille() 

end


function peli:luoPelaajat(hahmot, bottienMaara)

	-- print( nykyinenTaso.layers["Syntykohdat"].objects[1].x )
	
	botit = {} --Tyhjennetaan mahdolliset botit aiemmasta pelista
	
	voittaja = nil --Voittaja viela maarittamaton
	
	for i = 1, pelaajienMaara do
		--Botit
		if i <= bottienMaara then 
		 onkoBotti = true
		else 
		 onkoBotti = false	
		end		
		
		pelaajat[ i ] = pelaaja:luo( hahmot[i], pelaajienKontrollit[ i ], "Pelaaja " .. i,i,
		nykyinenTaso.layers["Syntykohdat"].objects[i].x,
		nykyinenTaso.layers["Syntykohdat"].objects[i].y, nykyinenTaso.layers["Syntykohdat"].objects[i].properties.suunta or "vasen", onkoBotti, maxElamat)
		
		print("Luotiin pelaaja "..i..", suunta "..nykyinenTaso.layers["Syntykohdat"].objects[i].properties.suunta or "vasen")
		
	end

end
