--[[
	liturgi.laula( "Herra olkoon teidan kanssanne" )
	seurakunta.laula( "Niin myos sinun henkesi kanssa." )
--]]


peli = {}

function peli:init()
			
	x  = 300
	y = 300
	r = 1

	painovoima = 200

	onkoPaussi = false

	pelaajat = {}

end

function peli:enter( self, tasonNimi, pelaajaMaara, elamienMaara)
	--Sade. Alle voi lisata ifin kaikille sadetta kayttaville kartoille
	sataako = false
	if tasonNimi == "Pilvenpiirtaja" then sataako=true end

	peliAlkanut = false
	TEsound.stop("musiikki")
	tasoNimi = tasonNimi
     
	--TODO valinta tälle 
	liikkuvaTausta=true

   if not peliAlkanut then
	
	nykyinenTaso = loader.load(tasonNimi..".tmx")
	nykyinenTaso:setDrawRange(0, 0, 2000, 960)
	
	if sataako then
		sade:uusi(nykyinenTaso, -500, -500, 1500, 5)
		TEsound.playLooping(AANI_POLKU.."/ymparisto/sade.ogg", "tausta")
	end	
	
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

	peli:luoPelaajat()
	
	peliAlkanut=true
		
   end
	testiajastin=0
	  
	--Taustaaanet, musiikki
	
end


function peli:update( dt )
    
  if peliAlkanut then
  
	if sataako then
		sade:update(dt)
	end
	
	self:liikutaPelaajat()
	
	--Tunarit-ruutu jos molemmat ovat kuolemassa pudotukseen
	if pelaajat[1].y > 500 and pelaajat[2].y > 500 and pelaajat[1].elamat == 1 and pelaajat[2].elamat == 1 then 
		Gamestate.switch(tunarit, tasoNimi, maxElamat)
	end	
	
	if not love.window.hasFocus( ) then
	 Gamestate.push(paussivalikko)
	end 
	
	--Huono vahikotunnistus
	if math.isAbout(pelaajat[1].x,pelaajat[2].x, 45) and math.isAbout(pelaajat[2].y, pelaajat[1].y, 32) then 
		for _, pelaaja in pairs( pelaajat ) do		    
			local toinen = pelaaja.numero%2+1
			local xEro = pelaaja.x - pelaajat[toinen].x		
			pelaaja:kontakti(pelaajat[toinen].suunta, pelaajat[toinen].tila, xEro)
		end
	end
		
	for _, pelaaja in pairs( pelaajat ) do

		pelaaja:update( dt, painovoima )

	end
	
	if nykKamera=="tavallinen" then
		camera:liikkuvaKamera(pelaajat[1].x,pelaajat[1].y,pelaajat[2].x,pelaajat[2].y)
	end
	
	if nykKamera=="Shake" then
		camera:shake(pelaajat[1].x,pelaajat[1].y,pelaajat[2].x,pelaajat[2].y)
	end
	
	if nykKamera=="kuolema" then
	  camera:kuolemaKamera(pelaajat[1].x,pelaajat[1].y,pelaajat[2].x,pelaajat[2].y)
	  
	  if camera:kuolemaKamera(pelaajat[1].x,pelaajat[1].y,pelaajat[2].x,pelaajat[2].y)==true then
	  
		nykKamera="tavallinen"
	   	print("Kamera:"..nykKamera)

	  end
	end
	
	--Paivitetaan animaatiot
		
	for i, pelaaja in pairs ( pelaajat ) do	
	  if pelaaja.numero==1 then
		pelaaja.nykAnim.red:update(dt)
	  else 
		pelaaja.nykAnim.blu:update(dt)
	  end
	end

	if pelaajat[1].yNopeus < 0 or pelaajat[2].yNopeus < 0 then
	
		hyppy_anim.blu:update(dt)
		hyppy_anim.red:update(dt)
	
	else
	
		hyppy_anim.blu:reset()
		hyppy_anim.red:reset()
	
	end
	
	
	if pelaajat[1].tila=="torjunta" or pelaajat[2].tila=="torjunta" then
	
		torjunta_anim.blu:update(dt)
		torjunta_anim.red:update(dt)
	 
	else
	
		torjunta_anim.blu:reset()
		torjunta_anim.red:reset()
		
	end
   end
end


		--Liikkuminen, pitaisi siirtaa varmaankin pelaaja-luokkaan
function peli:liikutaPelaajat()		
  for i, pelaaja in pairs ( pelaajat ) do	
   if not pelaaja.onkoBotti then
	if love.keyboard.isDown(pelaajienKontrollit[i].OIKEALLE) and not love.keyboard.isDown(pelaajienKontrollit[i].VASEMMALLE) then
	
        pelaajat[i]:liikuOikealle()
	
    elseif love.keyboard.isDown(pelaajienKontrollit[i].VASEMMALLE) and not love.keyboard.isDown(pelaajienKontrollit[i].OIKEALLE)  then
	
        pelaajat[i]:liikuVasemmalle()
	
	 elseif love.keyboard.isDown(pelaajienKontrollit[i].LYONTI) then
	    
        pelaajat[i]:lyonti()
	
	 elseif love.keyboard.isDown(pelaajienKontrollit[i].TORJUNTA) then
	 
        pelaajat[i]:torjunta()
		
	elseif love.keyboard.isDown(pelaajienKontrollit[i].HEITTOASE) then
	 
        pelaajat[i]:heitto()
			
	 else
		pelaajat[i]:pysahdy()
		
	 end
	 	
	if love.keyboard.isDown(pelaajienKontrollit[i].YLOS) then
        pelaajat[i]:hyppaa()
	end	
  else botti:update()
  end
 end 
end

function peli:draw()

    --local taso = _G[tasoNimi].attribute
	--Dynaaminen tausta
	if liikkuvaTausta then
		local taustaX = camera._x *-1 /5  -100 --Taustat liikkuvat kameran mukana, mutta maltillisemmin
		local taustaY = camera._y *-1 /10 -100
		local taustaZoom = camera.scaleX/10 --Ei jarkeva kayttaa
		love.graphics.draw(kuvat[tasoNimi.."_tausta.png"], taustaX, taustaY, 0, 2, 2) --Tason tausta piirtyy erikseen
	end
	camera:set() --Liikkuva kamera	
	
	if sataako then
		sade:draw()
	end
	
	nykyinenTaso:draw()

	for _, pelaaja in pairs( pelaajat ) do
		pelaaja:draw()	
	end
		
	camera:unset() --Ei enaa liikkuva kamera	
		
	if debugMode==true then

		love.graphics.print(pelaajat[1].tila, 0,0,0,0.5,0.5)
		love.graphics.print(pelaajat[2].tila,500,0,0,0.5,0.5)
		love.graphics.print(tostring(pelaajat[1].nykAnim), 0,100,0,0.5,0.5)
		love.graphics.print(tostring(pelaajat[2].nykAnim),500,100,0,0.5,0.5)
		love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 300, 10)
		
	end

end


function peli:keypressed( nappain )
		
	if nappain == "escape" then
		
		Gamestate.push(paussivalikko,"peli")
		
		print("Paussivalikko")
		
	end

end

function peli:asetaPaussille()

end


function peli:luoPelaajat()
	
	-- print( nykyinenTaso.layers["Syntykohdat"].objects[1].x )
	for i = 1, pelaajienMaara do

		pelaajat[ i ] = pelaaja:luo( "kekkonen", pelaajienKontrollit[ i ], "Pelaaja " .. i,i,
		nykyinenTaso.layers["Syntykohdat"].objects[i].x,
		nykyinenTaso.layers["Syntykohdat"].objects[i].y, "vasen" ,onkoBotti, maxElamat)
		
		print("Luotiin pelaaja "..i)
		
	end
	
end
