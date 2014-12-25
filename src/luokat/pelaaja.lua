--[[

--]]


pelaaja = {}
pelaaja.__index = pelaaja


function pelaaja:luo( pelaajanHahmo, pelaajanKontrollit, pelaajanNimi, pelaajanNumero, xLuomispiste, yLuomispiste, katsomisSuunta, onkoBotti, elamienMaara)
	
	local olio = {
		
		onkoBotti=onkoBotti,
		
		numero=pelaajanNumero,

		animSuunta=nil,
		--Pari ajastinta
		vahinkoAjastin=0,
		animAjastin=0,
		
		terveys=kekkonen.kestavyys,
		elamat =  elamienMaara,
		
		nykAnim=paikallaan_anim,
		animVoiVaihtua=true,
		
		hahmo = pelaajanHahmo,
		
		kontrollit = pelaajanKontrollit,

		tila = "",

		suunta = katsomisSuunta,

		x = xLuomispiste,
		y = yLuomispiste,

		xLuomispiste=xLuomispiste,
		yLuomispiste=yLuomispiste,
		
		voiHypata = true,
		voiLiikkua = true,	
		
		xNopeus = 0,
		yNopeus = 0,
		xNopeusMax=800,
		yNopeusMax=1000,
				
		osumaLaatikot = kekkonen:haeOsumaLaatikot( x, y )

		--pelaaja.xLuomispiste = xLuomispiste
		--pelaaja.yLuomispiste = yLuomispiste

	}
	setmetatable( olio, { __index = pelaaja } )

	return olio

end


function pelaaja:update( dt, painovoima )
	
	self.vahinkoAjastin = self.vahinkoAjastin-dt	
	self.animAjastin = self.animAjastin - dt
	
	self.xNopeus = math.clamp(self.xNopeus, -self.xNopeusMax, self.xNopeusMax)
        self.yNopeus = math.clamp(self.yNopeus, -self.yNopeusMax, self.yNopeusMax)

	if self.y> 700 then --Kuolema pudotessa
		self:kuolema()
	end	
	local map = nykyinenTaso
	local halfX = 32
    local halfY = 32
    
    -- painovoima
    self.yNopeus = self.yNopeus + (painovoima * 0.1)
    --Suomennus vähän kesken *köh*
    -- calculate vertical position and adjust if needed
    local seuraavaY = math.floor(self.y + (self.yNopeus * dt))
    if self.yNopeus < 0 then -- check upward
        if not(self:tarkistaTormays(map, self.x - halfX, seuraavaY - halfY))
            and not(self:tarkistaTormays(map, self.x + halfX - 1, seuraavaY - halfY)) then
            -- no collision, move normally
            self.y = seuraavaY
            self.voiHypata = false
        else
            -- collision, move to nearest tile border
            self.y = seuraavaY + map.tileHeight - ((seuraavaY - halfY) % map.tileHeight)
            self:tormays("katto")
        end
    elseif self.yNopeus > 0 then -- check downward
        if not(self:tarkistaTormays(map, self.x - halfX, seuraavaY + halfY))
            and not(self:tarkistaTormays(map, self.x + halfX - 1, seuraavaY + halfY)) then
            -- no collision, move normally
            self.y = seuraavaY
            self.voiHypata = false
        else
            -- collision, move to nearest tile border
            self.y = seuraavaY - ((seuraavaY + halfY) % map.tileHeight)
            self:tormays("lattia")
        end
    end

    -- calculate horizontal position and adjust if needed
    local seuraavaX = self.x + (self.xNopeus * dt)

    if self.xNopeus > 0 then -- check right
        if not(self:tarkistaTormays(map, seuraavaX + halfX, self.y - halfY))
            and not(self:tarkistaTormays(map, seuraavaX + halfX, self.y + halfY - 1)) then
            -- no collision
            self.x = seuraavaX
			
        else
            -- collision, move to nearest tile
            self.x = seuraavaX - ((seuraavaX + halfX) % map.tileWidth)
        end
    elseif self.xNopeus < 0 then -- check left
        if not(self:tarkistaTormays(map, seuraavaX - halfX, self.y - halfY))
            and not(self:tarkistaTormays(map, seuraavaX - halfX, self.y + halfY - 1)) then
            -- no collision
			
            self.x = seuraavaX
        else
            -- collision, move to nearest tile
            self.x = seuraavaX + map.tileWidth - ((seuraavaX - halfX) % map.tileWidth)
        end
    end
	
    --Pelaajan katsomissuunta
	if self.suunta=="vasen" then
		self.animSuunta=-1
	else
		self.animSuunta=1
    end
		
	--Paivita animaatiot
if self.animVoiVaihtua then	
	if self.yNopeus>0 then
		--Laskeutuminen
	    if self:tarkistaTormays(map, self.x, self.y+60) then
		 self.nykAnim=paikallaan_anim	
	     self.nykAnim = laskeutuminen_anim
		 self.animVoiVaihtua=false
		 self.animAjastin = 0.3
		 TEsound.play(kavelyAanet)
		 --Putoaminen
	    else	
		 self.tila="putoaminen"	
	 	 self.nykAnim=putoaminen_anim
		end
	--Hyppy
	elseif self.yNopeus<0 then
	
		self.tila="hyppy"
	
		self.nykAnim=hyppy_anim
	--Lyonti
	elseif self.tila=="lyonti" then
	
		self.nykAnim=lyonti_anim
	--Torjunta
	elseif self.tila=="torjunta" then
	
		self.nykAnim=torjunta_anim
	--Heitto	
	elseif self.tila=="heitto" then
	
		self.nykAnim=heitto_anim
		self.animVoiVaihtua=false
		self.animAjastin = 0.6
	--Kavely	
	elseif self.tila=="liikuOikealle" or self.tila=="liikuVasemmalle" then
		if kavelyAanetAjastin % 19 == 0 then --Toista aani jokunen kerta sekunnissa
			TEsound.play(kavelyAanet)
		end 
		self.nykAnim=kavely_anim
    --Paikallaan
	else
	
		self.nykAnim=paikallaan_anim	
		voiLiikkua=true
		
	end
	
end
	--Ajastimet
	kavelyAanetAjastin = kavelyAanetAjastin + 1 --TODO pitaisi tehda paremmin
	
	if self.animAjastin < 0 then --Ajastin animaation vaihtumiselle
	    self.animVoiVaihtua=true	
	    if self.numero==1 then
			laskeutuminen_anim.red:reset()
			heitto_anim.red:reset()
		else	
			laskeutuminen_anim.blu:reset()
			heitto_anim.blu:reset()
		end	
			
	end
		
end


function pelaaja:draw()
 --Piirretaan oikeat animaatiot molemmille pelaajille (blu/red)
 if self.tila=="paikallaan" then 
	if self.numero==1 then
		self.nykAnim.red:draw(self.x, self.y-13,0,self.animSuunta*1.5,1.5,16,30)
	else
		self.nykAnim.blu:draw(self.x, self.y-13,0,self.animSuunta*1.5,1.5,16,30)
	end	
 else
	if self.numero==1 then
		self.nykAnim.red:draw(self.x, self.y-10,0,self.animSuunta*1.5,1.5,16,30)
	else
		self.nykAnim.blu:draw(self.x, self.y-10,0,self.animSuunta*1.5,1.5,16,30)
	end
 end
 
 local x
 --Kameran liikkuminen ei vaikuta hudiin
 camera:unset()
 
 --HUD 
 if self.numero==2 then x=650 else x=10 end --Pelaajien 1 ja 2 hudit eri paikassa
	local elamat = 0
	if hudTila == "sydan" then
		if self.elamat > 5 then   --Sydanhudiin mahtuu vain 5
			love.graphics.print(self.elamat,x,510)
			love.graphics.draw(kuvat["heart.png"], x + 30, 510 , 0, 0.5, 0.5)
		else
			while elamat < self.elamat do
				love.graphics.draw(kuvat["heart.png"], x + elamat * 30, 510 , 0, 0.5, 0.5)
				elamat = elamat + 1
			end
		end	
	else
		love.graphics.print(self.elamat,x,510)
	end
	love.graphics.print(self.terveys..'%',x,550)
    camera:set()
end


function pelaaja:keypressed( nappain )


end

function pelaaja:tormays(kohde)

	if kohde=="lattia" then
	 	self.yNopeus = 0
		self.voiHypata=true
	end
	
	if kohde=="katto" then
		self.yNopeus = 0
	end

end 

function pelaaja:kontakti(suunta,hyokkays, xEro)
	--Suunta = mista hyokkays tulee, hyokkays = vastustajan state, xEro = ero pelaajien x-sijaintien valilla  
	
	local vastustajaOn --vastustajaOn = vastustajan sijainti(oikea/vasen)
	if xEro > 0 then  vastustajaOn="oikea" else vastustajaOn="vasen" end

	if  hyokkays=="lyonti" and vastustajaOn==suunta and not (self.tila=="torjunta" and suunta~=self.suunta) then

	   if self.vahinkoAjastin <= 0 then
		
		self.voiLiikkua = true
		
		TEsound.play(vahinkoAanet)
	
		self.terveys=self.terveys-math.random(10,20) --Terveys laskee random-maaran, taman voisi muuttaa paremmaksi
		
		nykKamera="Shake" --Kamera heiluu hetken
	
		if suunta=="vasen" then
		
			self.xNopeus=-400
	
		elseif suunta=="oikea" then
	
			self.xNopeus=400
	
		end

		self.nykAnim=vahinko_anim
		self.animVoiVaihtua=false
		self.vahinkoAjastin = 0.2 --Pieni hetki vahingoittumattomana
	    self.animAjastin = 0.5
		
		if self.terveys <= 0 then
	
			self:kuolema()
	 
		end 
	   end
	
	elseif hyokkays=="heitto" and vastustajaOn==suunta then
		if suunta=="vasen" then	
			self.xNopeus= 600
			self.yNopeus=-600
		elseif suunta=="oikea" then
			self.xNopeus=-600
			self.yNopeus=-600
		end
	
	end
	--tormays(jos pelaajat lähekkäin) 
	if math.abs(xEro)<35 then	
		--Pysahtyy seka liikkuu jompaankumpaan suntaan. Paattelee liikkumissunnan vastustajan suunnasta
		self:pysahdy(true)
		if vastustajaOn=="vasen" then 
			self.xNopeus=self.xNopeus-150
		elseif vastustajaOn=="oikea" then 
			self.xNopeus=self.xNopeus+150
		end
	
end
	
end

function pelaaja:hyppaa(  )

	if self.voiHypata then
		
		TEsound.play(hyppyAanet)
		
		self.yNopeus = kekkonen.hyppyNopeus
		
	end

end

function pelaaja:liikuOikealle(  )

	if voiLiikkua==true then
	
	 self.xNopeus = kekkonen.juoksuNopeus

	 self.suunta = "oikea"

	 self.tila="liikuOikealle"
	
	end
	
end


function pelaaja:liikuVasemmalle(  )
	
	if voiLiikkua == true then

		self.tila="liikuVasemmalle"
		self.xNopeus = kekkonen.juoksuNopeus * -1
		self.suunta = "vasen"
	
	end

end

function pelaaja:lyonti()

	self.xNopeus=0
	self.tila="lyonti"

end

function pelaaja:torjunta()

	self.xNopeus=0
	self.tila="torjunta"

end

function pelaaja:heitto() --Pitaa parannella

	self.xNopeus=0
	self.tila="heitto"

end

function pelaaja:pysahdy( heti )
	heti = heti or false --Pysahdytaanko seinaan
	if heti then 
		self.xNopeus = 0
	else --Pysahtyy hitaammin	
		--Jos maassa nopeasti
		if self.yNopeus == 0 then
			self.xNopeus=self.xNopeus*0.9
		end
		--Jos ilmassa hitaasti
		if self.yNopeus > 0 then
			self.xNopeus=self.xNopeus*0.95
		end
		if self.xNopeus == 0 then
			self.xNopeus=0
		end	
	
		if self.yNopeus<0.1 and self.yNopeus>-0.1 then
	
			self.tila="paikallaan"
	
		end
	end
end

function pelaaja:siirra( x, y )

end

function pelaaja:tarkistaTormays(map, x, y)
    -- get tile coordinates
    local kerros = map.layers["seinat"]

	local laattaX, laattaY = math.floor(x / map.tileWidth), math.floor(y / map.tileHeight)
   
    -- grab the tile at given point
    local laatta = map("Seinat")(laattaX, laattaY)

    -- return true if the point overlaps a solid tile
    return not(laatta == nil)
	
end


function pelaaja:kuolema() --Kuolee pelissa mutta ei valttamatta havia viela
	
	self.elamat = self.elamat-1
	self:pysahdy(true)
	if self.elamat == 0 then
		self:havio()
	else
	
		TEsound.play(TEHOSTE_POLKU.."Kuolema.ogg")
	
		nykKamera="kuolema"
	
		self.terveys=kekkonen.kestavyys
	
		print("Kamera:"..nykKamera)
	
		self.y=self.yLuomispiste
		self.x=self.xLuomispiste
	end
end

function pelaaja:havio() --Pelaaja haviaa pelin
	
	TEsound.play(TEHOSTE_POLKU.."Kuolema.ogg")
	Gamestate.switch(voittoRuutu, self.numero % 2 + 1) --Voitto toiselle pelaajalle
end
