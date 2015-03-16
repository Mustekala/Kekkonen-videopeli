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

	pelaajat = {}
	
end

function peli:enter( aiempi, tasonNimi, pelaajaMaara, elamienMaara, hahmot, bottienMaara)

	print("Aiempi state:"..aiempi.nimi) 
	
	intro = false
	if aiempi.nimi == "intro" then
		intro = true
	end
	
	--Sade. Alle voi lisata ifin kaikille sadetta kayttaville kartoille
	sataako = false					 --Kekkonen on vihainen: pakota sade
	if tasonNimi == "Pilvenpiirtaja" or aiempi.nimi == "tunarit" then sataako=true end

	TEsound.stop("musiikki")
	tasoNimi = tasonNimi

   if not peliAlkanut then
	
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
		
	if sataako then
		sade:uusi(nykyinenTaso, -500, -500, 1500, 5)
		TEsound.playLooping(AANI_POLKU.."/ymparisto/sade.ogg", "tausta")
	end	
end


function peli:update( dt )
    
  if peliAlkanut then
			
	kulunutAika = kulunutAika + dt --Ajastin pelin kulumiselle
	
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
			pelaaja:pysahdy( true )
		end
	else --Muuten voi liikkua
		self:liikutaPelaajat()
	end
	
	--Tunarit-ruutu jos molemmat ovat kuolemassa pudotukseen
	if pelaajat[1].y > 500 and pelaajat[2].y > 500 and pelaajat[1].elamat == 1 and pelaajat[2].elamat == 1 then 
		Gamestate.switch(tunarit, tasoNimi, maxElamat, {pelaajat[1].hahmo, pelaajat[2].hahmo})
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
	if nykKamera=="tavallinen" then
		camera:liikkuvaKamera(pelaajat[1].x,pelaajat[1].y,pelaajat[2].x,pelaajat[2].y)
	
	elseif nykKamera=="Shake" then
		camera:shake(pelaajat[1].x,pelaajat[1].y,pelaajat[2].x,pelaajat[2].y)
	
	elseif nykKamera=="kuolema" then
	  camera:kuolemaKamera(pelaajat[1].x,pelaajat[1].y,pelaajat[2].x,pelaajat[2].y)
	  
	  if camera:kuolemaKamera(pelaajat[1].x,pelaajat[1].y,pelaajat[2].x,pelaajat[2].y)==true then
	  
		nykKamera="tavallinen"
	   	print("Kamera:"..nykKamera)

	  end
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
   if not pelaaja.onBotti then
    if love.keyboard.isDown(pelaajienKontrollit[i].YLOS) then
	
        pelaaja:hyppaa()	
		
	end
	if love.keyboard.isDown(pelaajienKontrollit[i].OIKEALLE) and not love.keyboard.isDown(pelaajienKontrollit[i].VASEMMALLE) then
	
        pelaaja:liikuOikealle()
	
    elseif love.keyboard.isDown(pelaajienKontrollit[i].VASEMMALLE) and not love.keyboard.isDown(pelaajienKontrollit[i].OIKEALLE)  then
	
        pelaaja:liikuVasemmalle()
	
	 elseif love.keyboard.isDown(pelaajienKontrollit[i].LYONTI) then
	    
        pelaaja:lyonti()
	
	 elseif love.keyboard.isDown(pelaajienKontrollit[i].TORJUNTA) then
	 
        pelaaja:torjunta()
		
	elseif love.keyboard.isDown(pelaajienKontrollit[i].HEITTOASE) then
	 
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
	
	nykyinenTaso:draw()
	
	for _, pelaaja in pairs( pelaajat ) do
		pelaaja:draw()	
		if debugMode then
			love.graphics.circle("fill", pelaaja.x, pelaaja.y, 10)
		end
	end
	
	powerup:draw()

	camera:unset() --Ei enaa liikkuva kamera	
	
	if debugMode==true then

		love.graphics.print(pelaajat[1].tila, 0,0,0,0.5,0.5)
		love.graphics.print(pelaajat[2].tila,500,0,0,0.5,0.5)
		love.graphics.print(tostring(pelaajat[1].nykAnim), 0,100,0,0.5,0.5)
		love.graphics.print(tostring(pelaajat[2].nykAnim),500,100,0,0.5,0.5)
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
	
	for i = 1, pelaajienMaara do
		--Botit
		if i <= bottienMaara then 
		 onkoBotti = true
		else 
		 onkoBotti = false	
		end		
		
		pelaajat[ i ] = pelaaja:luo( hahmot[i], pelaajienKontrollit[ i ], "Pelaaja " .. i,i,
		nykyinenTaso.layers["Syntykohdat"].objects[i].x,
		nykyinenTaso.layers["Syntykohdat"].objects[i].y, "vasen", onkoBotti, maxElamat)
		
		print("Luotiin pelaaja "..i)
		
	end

end
