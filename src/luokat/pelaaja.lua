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
		kuollut = false, --Kuolema-ajastin lisatty 
		
		voiLyoda = false, --Voiko pelaaja lyoda
		voiHeittaa = false, --Voiko pelaaja heittaa
		
		terveys = _G[pelaajanHahmo].kestavyys,
		elamat = elamienMaara,
		
		osumaLaatikot = _G[pelaajanHahmo]:haeOsumaLaatikot( x, y ),
		
		nykAnim = _G[pelaajanHahmo].paikallaan_anim,
		
		animVoiVaihtua=true, --Voiko animaatio vaihtua
		animSuunta = 1,
		
		--Juoksunopeus on hahmon maarittama
		juoksuNopeus = _G[pelaajanHahmo].juoksuNopeus,
	
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
	
	--Ennen alkua ei voi lyoda
	Timer.add(3, function()	
		olio.voiLyoda = true --Voiko pelaaja lyoda
		olio.voiHeittaa = true --Voiko pelaaja heittaa
	end)
	
	return olio
	
end

--Lukitsee nykyisen animaation parametrin "aika" ajaksi
function pelaaja:lukitseAnimaatio(aika)
	self.animVoiVaihtua = false
	self.animAjastin = aika
end

function pelaaja:update( dt, painovoima )
	
	self.vahinkoAjastin = self.vahinkoAjastin-dt	
	self.animAjastin = self.animAjastin - dt

	self.xNopeus = math.clamp(self.xNopeus, -self.xNopeusMax, self.xNopeusMax)
    self.yNopeus = math.clamp(self.yNopeus, -self.yNopeusMax, self.yNopeusMax)

	if self.y > 700 then --Kuolema pudotessa
		self:kuolema()
	end	
	
	local map = nykyinenTaso
	local halfX = 32
    local halfY = 32

    -- painovoima
    self.yNopeus = self.yNopeus + painovoima
		
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
		 
		 self:lukitseAnimaatio( 0.3 )
		 TEsound.play(kavelyAanet)
		 --Putoaminen
	    else	
		 self.voiLiikkua = true --Pelaaja voi alkaa liikkumaan pudotessaan
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
		self:lukitseAnimaatio(0.35) 
	--Crit-lyonti
	elseif self.tila=="critLyonti" then	
	
		self.nykAnim = _G[self.hahmo].critLyonti_anim
		self:lukitseAnimaatio(0.35) 
				
	--Torjunta
	elseif self.tila=="torjunta" then
	
		self.nykAnim = _G[self.hahmo].torjunta_anim
		self:lukitseAnimaatio(0.3)
		
	--Heitto	
	elseif self.tila=="heitto" then	
	
		self.nykAnim = _G[self.hahmo].heitto_anim
		self:lukitseAnimaatio(0.5)		

	--Kaantyminen			
	elseif self.xNopeus > 0 and self.tila=="liikuVasemmalle" or self.xNopeus < 0 and self.tila=="liikuOikealle" then
	    
		self.nykAnim = _G[self.hahmo].kaantyminen_anim
		self:lukitseAnimaatio(0.2)
		
	--Kavely	
	elseif self.tila=="liikuOikealle" or self.tila=="liikuVasemmalle" then
		if kavelyAanetAjastin % 19 == 0 then --Toista aani jokunen kerta sekunnissa
			TEsound.play(kavelyAanet)
		end 
		self.nykAnim = _G[self.hahmo].kavely_anim
		_G[self.hahmo].kaantyminen_anim:reset()

    --Paikallaan
	else
		
		self.tila = "paikallaan"
		self.nykAnim = _G[self.hahmo].paikallaan_anim	
		self.voiLiikkua=true
		
	end
	
  end
			
    --Pelaajan katsomissuunta
	if self.suunta == "oikea" and self.nykAnim ~= _G[self.hahmo].kaantyminen_anim then --Kaantymisanimaatio lagaa suunnan kanssa
		self.animSuunta = 1 
	elseif self.suunta == "vasen" and self.nykAnim ~= _G[self.hahmo].kaantyminen_anim then
		self.animSuunta = -1 
	end
	
	--Ajastimet
	kavelyAanetAjastin = kavelyAanetAjastin + 1 --TODO pitaisi tehda paremmin
	
	if self.animAjastin < 0 then --Poista lukitus animaatiosta
	    self.animVoiVaihtua=true	
	end
	
	if self.animVoiVaihtua then
	--RESETOIDAAN ANIMAATIOT
		--Jos pelaaja ei lyo, resetoi lyontianimaatio
		if self.tila ~= "lyonti" then
			_G[self.hahmo].lyonti_anim:reset()
		end	
		if self.tila ~= "critLyonti" then
			_G[self.hahmo].critLyonti_anim:reset()
		end	
		--Jos pelaaja ei heita, resetoi heittoanimaatio
		if self.tila ~= "heitto" then
			_G[self.hahmo].heitto_anim:reset()
		end	
		--Jos pelaaja ei torju, resetoi torjuntaanimaatio
		if self.tila ~= "torjunta" then 	
			_G[self.hahmo].torjunta_anim:reset() 	
		end	
		--Jos pelaaja putoaa, resetoi laskeutumis- ja hyppyanimaatiot
		if self.tila=="putoaminen" then 	
			_G[self.hahmo].laskeutuminen_anim:reset()
			_G[self.hahmo].hyppy_anim:reset() 			
		end	
	end	
end


function pelaaja:draw()

 --Paikallaan-animaatio hieman eri y-kohdassa TODO korjaa animaatio
 if self.tila=="paikallaan" then 
	self.nykAnim:draw(self.x, self.y-13,0,self.animSuunta*1.5,1.5,20,30)	
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

function pelaaja:kontakti( hyokkaaja )
	
	vastustaja = hyokkaaja 

	--vHahmo = vastustajan hahmo
	local vHahmo = _G[vastustaja.hahmo]
	--hyokkays = vastustajan state
	local hyokkays = vastustaja.tila
	--xEro = ero pelaajien x-sijaintien valilla  
	local xEro = self.x - vastustaja.x	
	--suunta = vastustajan katsomissuunta
	local suunta = vastustaja.suunta
	
	local vastustajaOn --vastustajaOn = vastustajan sijainti(oikea/vasen)
	if xEro > 0 then  vastustajaOn="oikea" else vastustajaOn="vasen" end
	
	if (hyokkays=="lyonti" or hyokkays=="critLyonti") and vastustajaOn==suunta and not (self.tila=="torjunta" and suunta~=self.suunta) then

	   if self.vahinkoAjastin <= 0 then
		
		self.tila="vahinko"
		
		self.voiLiikkua = true
		
		--Jos tavallinen lyonti, tavallinen vahinko
		if hyokkays=="lyonti" then 
			TEsound.play(vahinkoAanet)
			self.terveys = self.terveys - vHahmo.lyontiVahinko --Terveys laskee vastustajan hahmon mukaan
		--Jos crit-lyonti, kaksinkertainen vahinko
		else
			TEsound.play(critAanet)
			self.terveys = self.terveys - vHahmo.lyontiVahinko * 2
		end
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
	
		self.voiLiikkua = false --Pelaajaa ei voi kontrolloida hetkeen(pudotessa taas voi)
		
		if suunta=="vasen" then	
			self.xNopeus= -300 * vHahmo.heittoVoima
			self.yNopeus=-500 * vHahmo.heittoVoima
		elseif suunta=="oikea" then
			self.xNopeus= 300 * vHahmo.heittoVoima
			self.yNopeus=-500 * vHahmo.heittoVoima
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
		
		self.voiHypata = false
	end

end

function pelaaja:liikuOikealle(  )

	if self.voiLiikkua then
	
		if self.xNopeus < self.juoksuNopeus  then
			self.xNopeus = self.xNopeus + 30
		else
			self:pysahdy()
		end	
	
		self.suunta = "oikea"

		self.tila="liikuOikealle"
	
	end
	
end


function pelaaja:liikuVasemmalle(  )
	
	if self.voiLiikkua then

		self.tila="liikuVasemmalle"
		if self.xNopeus > self.juoksuNopeus * -1 then
			self.xNopeus = self.xNopeus - 30
		else
			self:pysahdy()	
		end	
		self.suunta = "vasen"
	
	end

end

function pelaaja:lyonti()
	if self.voiLyoda then
		self.voiLyoda = false
		self.xNopeus=0
		if math.random(1, 100 / critTod) == 1 then --Random-crit(<3)
			self.tila="critLyonti"
		else
			self.tila="lyonti"
		end	
		Timer.add(0.5, function() self.voiLyoda = true end)
	end	
end

function pelaaja:torjunta()
	self.xNopeus=0
	self.tila="torjunta"
end

function pelaaja:heitto() --Pitaa parannella
	if self.voiHeittaa then
		self.voiHeittaa = false
		self.xNopeus=0
		self.tila="heitto"
		Timer.add(1, function() self.voiHeittaa = true end)
	end	
end

function pelaaja:pysahdy( heti )
	heti = heti or false --Pysahdytaanko seinaan
	if heti then 
		self.xNopeus = 0
	elseif self.voiLiikkua then --Pysahtyy hitaammin	
	
		--Jos ilmassa hitaasti
		if math.abs(self.yNopeus) > 1 then
			self.xNopeus=self.xNopeus*0.95
		--Jos maassa nopeasti	
		else
			self.xNopeus=self.xNopeus*0.9
		end
		--Jos about pysahtynyt, tilaksi paikallaan
		if math.isAbout(self.xNopeus, 0, 50) then
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
	
	self.nykAnim=_G[self.hahmo].kuolema_anim	
	self:lukitseAnimaatio(1)
	
	self:pysahdy(true)

	if not self.kuollut then	
		
		_G[self.hahmo].respawn_anim:reset() --Resetoidaan respawn-animaatio valmiiksi
		
		TEsound.play(TEHOSTE_POLKU.."Kuolema.ogg")
		self.elamat = self.elamat-1
	
		self.kuollut = true
		
		if self.elamat == 0 then
			
			voittaja = pelaajat[self.numero % 2 + 1] --Toinen pelaaja on voittaja
			print("Voittaja: " .. voittaja.numero)
			nykKamera = "voittajaKamera"
	
		end
						
		--Pelaaja respawnaa sekunnin kuluttua, tai peli loppuu
		Timer.add(1, 
		function() 
		
			self:pysahdy(true)
			
			self.kuollut = false
			self.terveys = _G[self.hahmo].kestavyys	
			TEsound.play(TEHOSTE_POLKU.."Respawn.ogg")
								
			if self.elamat == 0 then

				self:havio()
							
			else
				
				self.nykAnim=_G[self.hahmo].respawn_anim
				_G[self.hahmo].kuolema_anim:reset()
				
				self.y=self.yLuomispiste
				self.x=self.xLuomispiste 
							
				nykKamera="kuolema"
				
			end	
			--Lukitaan respawn-animaatio
			self:lukitseAnimaatio(1.7) 
			
		end) 
		
	end
		
end

function pelaaja:havio() --Pelaaja haviaa pelin
	function vaihdaState()
		--Tunarit-ruutu jos molemmat ovat kuolleet
		if  pelaajat[1].elamat < 1 and pelaajat[2].elamat < 1 then 
			Gamestate.switch(tunarit, tasoNimi, maxElamat, {pelaajat[1].hahmo, pelaajat[2].hahmo})
		else	
			Gamestate.switch(voittoRuutu, self.numero % 2 + 1) --Voitto toiselle pelaajalle
		end	
	end
	TEsound.play(TEHOSTE_POLKU.."Kuolema.ogg", "", 1, 1, vaihdaState)
end
