--[[

--]]


pelaaja = {}
pelaaja.__index = pelaaja


function pelaaja:luo( pelaajanHahmo, pelaajanKontrollit, pelaajanNimi, pelaajanNumero, xLuomispiste, yLuomispiste, katsomisSuunta, onkoBotti, elamienMaara)
	
	local olio = {
		
		onBotti = onkoBotti,
		
		numero=pelaajanNumero,

		--Pari ajastinta
		vahinkoAjastin=0,
		animAjastin=0,
		terveys = _G[pelaajanHahmo].kestavyys,
		elamat = elamienMaara,
		
		osumaLaatikot = _G[pelaajanHahmo]:haeOsumaLaatikot( x, y ),
		
		nykAnim = _G[pelaajanHahmo].paikallaan_anim,
		
		animVoiVaihtua=true,
		animSuunta = 1,
		
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
				
		--pelaaja.xLuomispiste = xLuomispiste
		--pelaaja.yLuomispiste = yLuomispiste

	}
	setmetatable( olio, { __index = pelaaja } )
	
	--Jos pelaaja on botti, luodaan uusi botti
	if onkoBotti then
		print("Uusi botti")
		botti:luo(pelaajanNumero)
	end
	
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
		
	--Paivita animaatiot
if self.animVoiVaihtua then	
	if self.yNopeus>0 then
		--Laskeutuminen
	    if self:tarkistaTormays(map, self.x, self.y+60) then
		 self.nykAnim=_G[self.hahmo].paikallaan_anim	
	     self.nykAnim = _G[self.hahmo].laskeutuminen_anim
		 self.animVoiVaihtua=false
		 self.animAjastin = 0.35
		 TEsound.play(kavelyAanet)
		 --Putoaminen
	    else	
		 self.tila="putoaminen"	
	 	 self.nykAnim = _G[self.hahmo].putoaminen_anim
		end
	--Hyppy
	elseif self.yNopeus<0 then
	
		self.tila="hyppy"
	
		self.nykAnim = _G[self.hahmo].hyppy_anim
	--Lyonti
	elseif self.tila=="lyonti" then
	
		self.nykAnim = _G[self.hahmo].lyonti_anim
	--Torjunta
	elseif self.tila=="torjunta" then
	
		self.nykAnim = _G[self.hahmo].torjunta_anim
	--Heitto	
	elseif self.tila=="heitto" then
	
		self.nykAnim = _G[self.hahmo].heitto_anim
		self.animVoiVaihtua=false
		self.animAjastin = 0.4
	--Kaantyminen			
	elseif self.xNopeus > 0 and self.tila=="liikuVasemmalle" or self.xNopeus < 0 and self.tila=="liikuOikealle" then
		self.nykAnim = _G[self.hahmo].kaantyminen_anim
		self.animVoiVaihtua=false
		self.animAjastin = 0.2
		
	--Kavely	
	elseif self.tila=="liikuOikealle" or self.tila=="liikuVasemmalle" then
		if kavelyAanetAjastin % 19 == 0 then --Toista aani jokunen kerta sekunnissa
			TEsound.play(kavelyAanet)
		end 
		self.nykAnim = _G[self.hahmo].kavely_anim
		_G[self.hahmo].kaantyminen_anim:reset()
		
    --Paikallaan
	else
	
		self.nykAnim = _G[self.hahmo].paikallaan_anim	
		self.voiLiikkua=true
		
	end

end
			
    --Pelaajan katsomissuunta
	if self.suunta == "oikea" and self.animVoiVaihtua then
		self.animSuunta = 1 
	elseif self.suunta == "vasen" and self.animVoiVaihtua then
		self.animSuunta = -1 
	end
	
	--Ajastimet
	kavelyAanetAjastin = kavelyAanetAjastin + 1 --TODO pitaisi tehda paremmin
	
	if self.animAjastin < 0 then --Ajastin animaation vaihtumiselle
	    self.animVoiVaihtua=true	
	end
	
	--RESETOIDAAN ANIMAATIOT
	--Jos pelaaja ei heita, resetoi heittoanimaatio
	if not self.tila=="heitto" then
		_G[self.hahmo].heitto_anim:reset()
	end	
	--Jos pelaaja ei torju, resetoi torjuntaanimaatio
	if not self.tila=="torjunta" then 	
		_G[self.hahmo].torjunta_anim:reset() 		
	end	
	--Jos pelaaja putoaa, resetoi laskeutumisanimaatio
	if self.tila=="putoaminen" then 	
		_G[self.hahmo].laskeutuminen_anim:reset() 		
	end	
end


function pelaaja:draw()

 --Paikallaan-animaatio hieman eri y-kohdassa
 if self.tila=="paikallaan" then 
	self.nykAnim:draw(self.x, self.y-13,0,self.animSuunta*1.5,1.5,16,30)	
 else
	self.nykAnim:draw(self.x, self.y-10,0,self.animSuunta*1.5,1.5,16,30)
 end
 
 --Kameran liikkuminen ei vaikuta hudiin
 camera:unset()
 
 --HUD 
 local x
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

		self.nykAnim = _G[self.hahmo].vahinko_anim
		self.animVoiVaihtua=false
		self.vahinkoAjastin = 0.2 --Pieni hetki vahingoittumattomana
	    self.animAjastin = 0.5
		
		if self.terveys <= 0 then
	
			self:kuolema()
	 
		end 
	   end
	
	elseif hyokkays=="heitto" and vastustajaOn==suunta then
		self.voiLiikkua = false
		if suunta=="vasen" then	
			self.xNopeus= -400
			self.yNopeus=-600
		elseif suunta=="oikea" then
			self.xNopeus= 400
			self.yNopeus=-600
		end
	
	end
	--tormays(jos pelaajat lähekkäin) 
	if math.abs(xEro)<30 then	
		--Pysahtyy seka liikkuu jompaankumpaan suntaan. Paattelee liikkumissunnan vastustajan suunnasta
		self:pysahdy(true)
		if vastustajaOn=="vasen" then 
			self.xNopeus=self.xNopeus-100
		elseif vastustajaOn=="oikea" then 
			self.xNopeus=self.xNopeus+100
		end
	
end
	
end

function pelaaja:hyppaa(  )

	if self.voiHypata then
		
		TEsound.play(hyppyAanet)
		
		self.yNopeus = _G[self.hahmo].hyppyNopeus
		
	end

end

function pelaaja:liikuOikealle(  )

	if self.voiLiikkua then
	
		if self.xNopeus < _G[self.hahmo].juoksuNopeus  then
			self.xNopeus = self.xNopeus + 20
		end	
	
		self.suunta = "oikea"

		self.tila="liikuOikealle"
	
	end
	
end


function pelaaja:liikuVasemmalle(  )
	
	if self.voiLiikkua then

		self.tila="liikuVasemmalle"
		if self.xNopeus > _G[self.hahmo].juoksuNopeus * -1 then
			self.xNopeus = self.xNopeus - 20
		end	
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
	
		self.terveys = _G[self.hahmo].kestavyys
	
		print("Kamera:"..nykKamera)
	
		self.y=self.yLuomispiste
		self.x=self.xLuomispiste
	end
end

function pelaaja:havio() --Pelaaja haviaa pelin
	
	TEsound.play(TEHOSTE_POLKU.."Kuolema.ogg")
	Gamestate.switch(voittoRuutu, self.numero % 2 + 1) --Voitto toiselle pelaajalle
end
