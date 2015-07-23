botti = {}
botit = {}
--Botti ottaa komentoonsa pelaajan, jonka numeron se saa parametrina
--Aika pahasti viela kesken
function botti:luo(numero)
	table.insert(botit, {
		numero = numero, --Botin ohjattava pelaaja
		numero2 = numero % 2 + 1, --toinen pelaaja
		tila = "puolustava",
		laskuri = 0 
		})
end

function botti:update(dt)
	for i, bot in ipairs(botit) do
		local tamaBotti = pelaajat[bot.numero] --Taman botin ohjaama pelaaja
		local pelaaja = pelaajat[bot.numero2]  --toinen pelaaja
		
		--Jos oma terveys on alle toisen pelaajan terveys/1.5, puolustava
		if tamaBotti.terveys < pelaaja.terveys / 1.5 then 
			bot.tila = "puolustava" --Puolustava pitaa etaisyytta
		else	
			bot.tila = "hyokkaava"  --Hyokkaava pyrkii lahelle
		end

		local haluttuEtaisyys 
		
		if bot.tila == "hyokkaava" then 
			haluttuEtaisyys = 50
		else
			haluttuEtaisyys = 200
		end
		
		local liikkumisSuunta = 1
		
		--Jos toinen pelaaja ei ole halutulla etaisyydella tai putoamassa/kuollut, seuraa sitä
		if pelaaja.yNopeus < 200 and not pelaaja.kuollut then
			if tamaBotti.x < pelaaja.x - haluttuEtaisyys and pelaaja.yNopeus < 400 then
				tamaBotti:liikuOikealle()
				liikkumisSuunta = 1	
			elseif	tamaBotti.x > pelaaja.x + haluttuEtaisyys and pelaaja.yNopeus < 400 then
				tamaBotti:liikuVasemmalle()
				liikkumisSuunta = -1
			elseif not math.isAbout(tamaBotti.y, pelaaja.y, 50) then
				haluttuEtaisyys = 0
			end
		else 
			tamaBotti:pysahdy()			
		end
		--Hyppää kuilujen yli
		if not tamaBotti:tarkistaTormays(nykyinenTaso, tamaBotti.x + 10 *liikkumisSuunta, tamaBotti.y+60) then
			--Mutta vain jos toisella puolella on taso
			if tamaBotti:tarkistaTormays(nykyinenTaso, tamaBotti.x+250*liikkumisSuunta, tamaBotti.y+60) then 
				tamaBotti:hyppaa()			
			--Muuten pysahdy, paitsi jos ilmassa	
			elseif tamaBotti.tila ~= "hyppy" and tamaBotti.tila ~=  "putoaminen" then
				tamaBotti:pysahdy()
			end	
		end
	
		--Jos edessa seina, hyppaa
		if tamaBotti:tarkistaTormays(nykyinenTaso, tamaBotti.x+33*liikkumisSuunta, tamaBotti.y) then
			if tamaBotti.tila == "liikuOikealle" or tamaBotti.tila == "liikuVasemmalle" then
				tamaBotti:hyppaa()	
			end	
		end
		
		--Botti toimii laskurin mukaan, ja toistaa liikkeita n. 2 sekunnin sarjoissa
		--Math.random lisaa pikkuisen satunnaisuutta botin toimiin
		bot.laskuri = bot.laskuri + math.random(1,2)
		
		--Botti kaantyy toisen pelaajan suuntaan, mutta ei heti (liian op)
		if bot.laskuri < 10 then 
			if tamaBotti.x - pelaaja.x < 0 then 
				tamaBotti.suunta = "oikea"
			else	
				tamaBotti.suunta = "vasen"
			end	
		end
		
		
		if bot.laskuri > 120 then bot.laskuri = 0 end	
	
		if math.dist(tamaBotti.x, pelaaja.x) < 50 then

			if bot.laskuri<60 then
				tamaBotti:lyonti() 
			else if bot.laskuri<120 then
				tamaBotti:torjunta() 
			else if bot.laskuri==120 then	
				tamaBotti:heitto()
			else 
				tamaBotti:pysahdy()
			end
			
			--Korvaa keyreleased-komennot 
			tamaBotti.voiLyoda = true
			tamaBotti.voiHeittaa = true
			tamaBotti.voiTorjua = true
			
		end

	  end	
	 end
	end
end