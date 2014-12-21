botti = {}
--Botti ottaa komentoonsa pelaajan, jonka numeron se saa parametrina
--Aika pahasti viela kesken
function botti:luo(numero)
 botti.numero = numero --Botin ohjattava pelaaja
 botti.numero2 = self.numero % 2 + 1 --toinen pelaaja
 botti.tila = "puolustava"
 botti.laskuri = 0 
end

function botti:update(dt)

 local liikkumisSuunta = 1
 if pelaajat[self.numero].terveys < 50 then 
	self.tila = "puolustava" 
 else	
	self.tila = "hyokkaava" 
 end
 local haluttuEtaisyys
 if self.tila == "hyokkaava" then 
	haluttuEtaisyys = 50
 else
	haluttuEtaisyys = 250
 end

	 --Jos toinen pelaaja ei ole lähellä tai putoamassa, seuraa sitä
	if pelaajat[self.numero].x < pelaajat[self.numero2].x -haluttuEtaisyys and pelaajat[self.numero2].yNopeus < 400 then
		pelaajat[self.numero]:liikuOikealle()
		liikkumisSuunta = 1	
	elseif	pelaajat[self.numero].x > pelaajat[self.numero2].x +haluttuEtaisyys and pelaajat[self.numero2].yNopeus < 400 then
		pelaajat[self.numero]:liikuVasemmalle()
		liikkumisSuunta = -1
	else pelaajat[self.numero]:pysahdy()	
	end
			
	--Hyppää kuilujen yli
	if not pelaajat[self.numero]:tarkistaTormays(nykyinenTaso, pelaajat[self.numero].x+20*liikkumisSuunta, pelaajat[self.numero].y+60) then
		--Mutta vain jos toisella puolella on taso
		if pelaajat[self.numero]:tarkistaTormays(nykyinenTaso, pelaajat[self.numero].x+150*liikkumisSuunta, pelaajat[self.numero].y+60) then 
			pelaajat[self.numero].xSpeed = 100 * liikkumisSuunta
			pelaajat[self.numero]:hyppaa()			
		else 
			pelaajat[self.numero]:pysahdy()
		end	
	end
	
	if math.dist(pelaajat[self.numero].x,pelaajat[self.numero2].x )< 60 then
		
		self.laskuri = self.laskuri + 1
		print(self.laskuri)
		if self.laskuri > 150 then self.laskuri = 0 end	

		if self.laskuri<60 then
			pelaajat[self.numero]:lyonti() 
		else if self.laskuri<120 then
			pelaajat[self.numero]:torjunta() 
		else if self.laskuri==120 then	
			pelaajat[self.numero]:heitto()
		else 
			pelaajat[self.numero]:pysahdy()
		end
		
	end
 end	
end
end